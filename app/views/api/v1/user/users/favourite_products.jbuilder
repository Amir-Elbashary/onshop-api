json.array! @favourite_products do |product|
  json.partial! 'api/v1/shared/product', product: product

  json.variants product.variants do |variant|
    json.partial! 'api/v1/shared/variant', variant: variant
  end
end
