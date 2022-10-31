class Order < ApplicationRecord
  include ActiveModel::Dirty

  define_attribute_methods

  belongs_to :user
  belongs_to :shipping_address, class_name: 'Address', optional: true
  has_many :line_items, dependent: :destroy, after_add: :calculate_price_and_discount_price_on_add, after_remove: :calculate_price_and_discount_price_on_remove, before_add: :prevent_multiple_purchase_of_same_deal, autosave: true
  has_many :order_transactions, dependent: :destroy
  has_many :deals, through: :line_items

  after_update :cancel_and_refund_order, if: [:cancelled?, ->(order) { order.status_previously_was != 'cancelled' }]
  after_update :send_status_updation_mail, if: :status_previously_changed?
  
  enum status: [ :in_cart, :placed, :in_transit, :out_for_delivery, :shipped, :delivered, :cancelled ]

  def calculate_price_and_discount_price_on_add(line_item)
    self.price += line_item.discounted_price
    self.discount_price += line_item.loyality_discounted_price
    self.price_after_tax += line_item.net_price_after_tax

    save

    if line_item.deal.live? && order_transactions.last.try(:paid?)
      line_item.deal.current_quantity -= 1
      line_item.deal.save
    end
  end

  def calculate_price_and_discount_price_on_remove(line_item)
    self.price -= line_item.discounted_price
    self.discount_price-= line_item.loyality_discounted_price
    self.price_after_tax -= line_item.net_price_after_tax

    price.zero? ? destroy : save

    if line_item.deal.live?
      line_item.deal.current_quantity += 1
      line_item.deal.save
    end
  end

  def prevent_multiple_purchase_of_same_deal(line_item)
    user.orders.each do |order|
      order.line_items.each do |user_line_item|
        throw :abort if user_line_item.deal_id == line_item.deal_id
      end
    end
  end

  def cancel_and_refund_order
    latest_transaction = order_transactions.last
    line_items.each do |line_item|
      line_item.deal.current_quantity += 1
      line_item.deal.save
    end
    Stripe::Refund.create({payment_intent: latest_transaction.payment_intent_id, amount: latest_transaction.amount.to_i})
    latest_transaction.update(status: 'refunded')
  end

  def send_status_updation_mail
    OrderMailer.status_update(self, order_transactions.last).deliver_later
  end
end
