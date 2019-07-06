json.variant do
  json.partial! 'api/v1/shared/variant', variant: @variant
end

json.product do
  json.partial! 'api/v1/shared/product', product: @product
end
