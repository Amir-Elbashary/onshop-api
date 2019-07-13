class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.string :email
      t.integer :status, default: 1

      t.timestamps
    end

    add_index :subscriptions, :status
  end
end
