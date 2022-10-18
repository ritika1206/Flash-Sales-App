class ChangeStatusInOrderTransactions < ActiveRecord::Migration[7.0]
  def change
    change_column :order_transactions, :status, :integer
  end
end
