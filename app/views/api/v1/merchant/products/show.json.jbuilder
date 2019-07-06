json.partial! 'api/v1/shared/product', product: @product

json.variants do
  json.array! @variants, partial: 'api/v1/shared/variant', as: :variant
end
