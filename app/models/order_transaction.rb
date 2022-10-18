class OrderTransaction < ApplicationRecord
  belongs_to :order
  belongs_to :address, foreign_key: 'shipping_address_id'

  enum status: [ :unpaid, :refunded, :paid ]
  
  after_create_commit :send_placement_confirmation_mail, if: ->(transaction) { transaction.paid? }

  def send_placement_confirmation_mail
    OrderTransactionMailer.order_placement_confirmation(self).deliver_now
  end
end
