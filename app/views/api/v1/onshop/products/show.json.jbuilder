json.partial! 'api/v1/shared/product', product: @product

json.price @product.variants.pluck(:price).sort.first

json.variants do
  json.array! @product.variants, partial: 'api/v1/shared/variant', as: :variant
end

json.reviews do
  json.array! @reviews, partial: 'api/v1/shared/review', as: :review
end

json.related_product do
  json.array! @related_products, partial: 'api/v1/shared/product', as: :product
end
