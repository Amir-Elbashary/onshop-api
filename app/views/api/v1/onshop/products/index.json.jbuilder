json.products_found @products.count

json.products do
  json.array! @products, partial: 'product', as: :product
end
