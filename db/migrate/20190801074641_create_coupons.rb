class CreateCoupons < ActiveRecord::Migration[5.2]
  def change
    create_table :coupons do |t|
      t.integer :percentage
      t.string :code
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
