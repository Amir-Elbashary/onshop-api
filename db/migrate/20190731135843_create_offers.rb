class CreateOffers < ActiveRecord::Migration[5.2]
  def change
    create_table :offers do |t|
      t.references :category, foreign_key: true
      t.integer :percentage
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
