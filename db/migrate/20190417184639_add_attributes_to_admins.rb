class AddAttributesToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :authentication_token, :string
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
    add_column :admins, :avatar, :string
  end
end
