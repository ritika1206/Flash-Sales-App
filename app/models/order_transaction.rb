class OrderTransaction < ApplicationRecord
  belongs_to :order
  belongs_to :address, foreign_key: 'shipping_address_id'

  after_create_commit :send_placement_confirmation_mail, if: :paid?

  enum status: [ :unpaid, :refunded, :paid ]
  
  def send_placement_confirmation_mail
    OrderTransactionMailer.order_placement_confirmation(self).deliver_later
  end

  def latest_transaction(order_id)
    OrderTransaction.where(order_id: order_id).order(created_at: :desc).first
  end
end
