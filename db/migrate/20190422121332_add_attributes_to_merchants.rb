class AddAttributesToMerchants < ActiveRecord::Migration[5.2]
  def change
    add_column :merchants, :authentication_token, :string
    add_column :merchants, :first_name, :string
    add_column :merchants, :last_name, :string
    add_column :merchants, :avatar, :string
  end
end
