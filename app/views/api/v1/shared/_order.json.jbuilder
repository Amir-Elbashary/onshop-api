json.extract! order, :id, :user_id, :cart_id, :order_number, :total_items, :total_price, :payment_method, :status, :created_at, :updated_at

if order.coupon_code
  if active_coupon?(order.coupon_code)
    json.price (order.total_price - (order.total_price * coupon_discount_percentage(order.coupon_code) / 100))
  else
    json.price order.total_price
  end
else
  json.price order.total_price
end
