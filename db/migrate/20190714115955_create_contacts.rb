class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :user_name
      t.string :email
      t.string :phone_number
      t.text :message
      t.integer :status, default: 1

      t.timestamps
    end

    add_index :contacts, :status
  end
end
