json.extract! item, :id, :cart_id, :variant_id, :quantity, :created_at, :updated_at

json.variant do
  json.id item.variant.id
  json.product_id item.variant.product_id
  json.price item.variant.price
  json.discount item.variant.discount
  json.image item.variant.image
  json.quantity item.variant.quantity
  json.color_en item.variant.color_en
  json.color_ar item.variant.color_ar
  json.size_en item.variant.size_en
  json.size_ar item.variant.size_ar
  json.created_at item.variant.created_at
  json.updated_at item.variant.updated_at
end

json.product do
  json.id item.variant.product.id
  json.merchant_id item.variant.product.merchant_id
  json.category_id item.variant.product.category_id
  json.image item.variant.product.image
  json.name_en item.variant.product.name_en
  json.name_ar item.variant.product.name_ar
  json.description_en item.variant.product.description_en
  json.description_ar item.variant.product.description_ar
  json.created_at item.variant.product.created_at
  json.updated_at item.variant.product.updated_at
end
