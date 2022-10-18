class Address < ApplicationRecord
  PLACE_NAME_REGEX = /\A(\b[A-Z]+\b[\s]*){1,5}\z/i
  LINE_NAME_REGEX = /\A(\b\w+\b[\s]*){1,5}\z/i
  POSTAL_CODE_LENGTH_RANGE = 5..6

  has_many :order_transactions, foreign_key: 'shipping_address_id'
  has_many :orders, foreign_key: 'shipping_address_id'
  belongs_to :user

  validates :country, :line1, :city, :state, presence: :true
  validates :country, :city, :state, format: { with: PLACE_NAME_REGEX, message: 'can contain aphabets only' }, allow_blank: true
  validates :line1, :line2, format: { with: LINE_NAME_REGEX }, allow_blank: true
  validates :postal_code, presence: true
  validates :postal_code, numericality: true, length: { in: POSTAL_CODE_LENGTH_RANGE }, allow_blank: true

  def to_s
    "#{[country, line1, line2, city, state, postal_code].join(', ')}"
  end
end
