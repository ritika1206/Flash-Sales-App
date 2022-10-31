class AddColumnToLineItemsAndOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :price_after_tax, :decimal, precision: 10, scale: 2, default: 0
    add_column :line_items, :net_price_after_tax, :decimal, precision: 10, scale: 2, default: 0
  end
end
