class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.references :merchant, foreign_key: true
      t.references :category, foreign_key: true
      t.string :name
      t.text :description
      t.string :image
      t.timestamps
    end
  end
end
