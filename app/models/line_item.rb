class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :deal

  def calculate_loyality_discount_percentage
    user_order_number = Order.count(email: line_item.order.user.email)
    case
    when user_order_number >= 6
      loyality_discount_percentage = 5
    when user_order_number = 5
      loyality_discount_percentage = 4
    when user_order_number = 4
      loyality_discount_percentage = 3
    when user_order_number = 3
      loyality_discount_percentage = 2
    when user_order_number = 2
      loyality_discount_percentage = 1
    end
  end

  def calculate_loyality_discount_price
    loyality_discount_price = discount_price*((100-loyality_discount_percentage)/100)
  end
end
