json.products_found @products.count

json.products do
  json.array! @products do |product|
    json.partial! 'api/v1/shared/product', product: product
    json.variants do
      json.array! product.variants, partial: 'api/v1/shared/variant', as: :variant
    end
  end
end
