class CreateDiscounts < ActiveRecord::Migration[5.2]
  def change
    create_table :discounts do |t|
      t.references :merchant, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :percentage
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
