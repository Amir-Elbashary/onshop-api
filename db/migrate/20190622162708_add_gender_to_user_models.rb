class AddGenderToUserModels < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :gender, :integer, default: 0
    add_column :merchants, :gender, :integer, default: 0
    add_column :users, :gender, :integer, default: 0

    add_index :admins, :gender
    add_index :merchants, :gender
    add_index :users, :gender
  end
end
