class CreateVariants < ActiveRecord::Migration[5.2]
  def change
    create_table :variants do |t|
      t.references :product, foreign_key: true
      t.string :color
      t.string :size
      t.decimal :price
      t.decimal :discount
      t.string :image
      t.timestamps
    end
  end
end
