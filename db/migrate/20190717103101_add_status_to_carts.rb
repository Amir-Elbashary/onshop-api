class AddStatusToCarts < ActiveRecord::Migration[5.2]
  def change
    add_column :carts, :status, :integer, default: 1
    add_index :carts, :status
  end
end
