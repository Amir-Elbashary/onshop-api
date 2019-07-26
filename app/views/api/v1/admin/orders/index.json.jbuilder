json.array! @orders do |order|
  json.partial! 'api/v1/shared/order', order: order
  json.user_name order.user.full_name
  json.items do
    json.array! order.cart.items do |item|
      json.partial! 'api/v1/shared/item', item: item
      json.variant do
        json.partial! 'api/v1/shared/variant', variant: item.variant
        json.product do
          json.partial! 'api/v1/shared/product', product: item.variant.product
        end
      end
    end
  end
end
