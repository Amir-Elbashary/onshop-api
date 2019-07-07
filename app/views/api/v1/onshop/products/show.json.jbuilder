json.partial! 'api/v1/shared/product', product: @product

json.price @product.variants.pluck(:price).sort.first

json.variants do
  json.array! @product.variants, partial: 'api/v1/shared/variant', as: :variant
end

json.reviews do
  json.array! @reviews, partial: 'api/v1/shared/review', as: :review
end

json.related_product do
  json.array! @related_products do |related_product|
    json.partial! 'api/v1/shared/product', product: related_product
    json.variants do
      json.array! related_product.variants, partial: 'api/v1/shared/variant', as: :variant
    end
  end
end
