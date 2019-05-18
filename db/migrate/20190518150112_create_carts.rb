class CreateCarts < ActiveRecord::Migration[5.2]
  def change
    create_table :carts do |t|
      t.references :user, foreign_key: true
      t.integer :state, default: 1
      t.timestamps
    end

    add_index :carts, :state
  end
end
