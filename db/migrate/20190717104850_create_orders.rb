class CreateOrders < ActiveRecord::Migration[5.2]
  def change
    create_table :orders do |t|
      t.references :user, foreign_key: true
      t.references :cart, foreign_key: true
      t.integer :order_number
      t.integer :total_items, default: 0
      t.decimal :total_price, default: 0

      t.timestamps
    end
  end
end
