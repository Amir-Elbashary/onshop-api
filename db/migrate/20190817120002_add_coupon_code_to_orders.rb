class AddCouponCodeToOrders < ActiveRecord::Migration[5.2]
  def change
    add_column :orders, :coupon_code, :string
  end
end
