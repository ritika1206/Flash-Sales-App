class Order < ApplicationRecord
  has_many :line_items

  enum status: { 
    in_cart: 'in_cart',
    placed: 'placed',
    in_transit: 'in_transit',
    out_for_delivery: 'out_for_delivery',
    shipped: 'shipped',
    delivered: 'delivered'
  }

  # validates :discount_price_in_cents, :loyality_discounted_price, numericality: true, allow_blank: true
end
