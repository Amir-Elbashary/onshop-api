class AddStatusToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :status, :integer, default: 0
    add_index :orders, :status
  end
end
