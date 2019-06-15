class AddShippingAddressToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :shipping_address, :string
  end
end
