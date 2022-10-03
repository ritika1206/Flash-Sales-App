class Order < ApplicationRecord
  has_many :line_items, dependent: :destroy
  belongs_to :user

  enum status: { 
    in_cart: 'in_cart',
    placed: 'placed',
    in_transit: 'in_transit',
    out_for_delivery: 'out_for_delivery',
    shipped: 'shipped',
    delivered: 'delivered'
  }

  # validates :discount_price_in_cents, :loyality_discounted_price, numericality: true, allow_blank: true

  # def calculate_price
  #   line_items.each { |line_item| price += line_item.discount_price }
  # end

  # def calculate_discount_price
  #   line_items.each { |line_item| price += line_item.loyality_discount_price }
  # end
end
