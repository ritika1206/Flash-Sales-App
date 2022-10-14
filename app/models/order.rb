class Order < ApplicationRecord
  include ActiveModel::Dirty

  define_attribute_methods

  has_many :line_items, dependent: :destroy, after_add: :calculate_price_and_discount_price_on_add, after_remove: :calculate_price_and_discount_price_on_remove, before_add: :prevent_multiple_purchase_of_same_deal, autosave: true
  belongs_to :user
  has_one :order_transaction, dependent: :destroy
  has_many :deals, through: :line_items
  belongs_to :shipping_address, class_name: 'Address', optional: true

  enum status: [ :in_cart, :placed, :in_transit, :out_for_delivery, :shipped, :delivered, :cancelled ]

  after_update :cancel_and_refund_order, if: :cancelled?
  after_update :send_status_updation_mail, if: :status_previously_changed?

  # validates :discount_price_in_cents, :loyality_discounted_price, numericality: true, allow_blank: true

  def calculate_price_and_discount_price_on_add(line_item)
    self.price += line_item.discounted_price
    self.discount_price += line_item.loyality_discounted_price
    save

    line_item.deal.current_quantity -= 1
    line_item.deal.save
  end

  def calculate_price_and_discount_price_on_remove(line_item)
    self.price -= line_item.discounted_price
    self.discount_price-= line_item.loyality_discounted_price
    if price == 0
      destroy
    else
      save
    end

    line_item.deal.current_quantity += 1
    line_item.deal.save
  end

  def prevent_multiple_purchase_of_same_deal(line_item)
    user.orders.each do |order|
      order.line_items.each do |user_line_item|
        throw :abort if user_line_item.deal_id == line_item.deal_id
      end
    end
  end

  def cancel_and_refund_order
    line_items.each do |line_item|
      line_item.deal.current_quantity += 1
      line_item.deal.save
    end
    Stripe::Refund.create({payment_intent: order_transaction.payment_intent_id, amount: order_transaction.amount.to_i})
    order_transaction.update(status: 'refunded')
  end

  def send_status_updation_mail
    OrderMailer.status_update(self, order_transaction).deliver_now
  end
end
