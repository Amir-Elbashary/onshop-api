class CreateItems < ActiveRecord::Migration[5.2]
  def change
    create_table :items do |t|
      t.references :cart, foreign_key: true
      t.references :variant, foreign_key: true
      t.integer :quantity, default: 0
      t.timestamps
    end
  end
end
