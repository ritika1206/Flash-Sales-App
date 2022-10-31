class RenameQuantityAndAddInitialQuantityToDeals < ActiveRecord::Migration[7.0]
  def change
    rename_column :deals, :quantity, :current_quantity
    add_column :deals, :initial_quantity, :integer
  end
end
