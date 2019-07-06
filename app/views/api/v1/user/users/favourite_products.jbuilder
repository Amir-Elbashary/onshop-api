json.array! @favourite_products do |product|
  json.partial! 'api/v1/shared/product', product: product
end
