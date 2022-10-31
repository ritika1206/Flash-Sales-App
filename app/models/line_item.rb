class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :deal

  before_validation :calculate_loyality_discount_percentage_and_price
  before_validation :calculate_price_after_tax

  def calculate_loyality_discount_percentage_and_price
    user_order_number = Order.where(user_id: order.user_id).count
    self.loyality_discount_percentage = ([5, user_order_number - 1].min).round(2)
    self.loyality_discounted_price = (discounted_price * ((100 - loyality_discount_percentage) / 100.0)).round(2)
  end

  def calculate_price_after_tax
    if loyality_discounted_price == 0
      self.net_price_after_tax = price_after_tax(discounted_price, deal.tax_percentage)
    else
      self.net_price_after_tax = price_after_tax(loyality_discounted_price, deal.tax_percentage)
    end
  end

  def price_after_tax(price, tax)
    (price * ((100 + tax)/100))
  end
end
