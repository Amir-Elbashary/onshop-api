json.array! @cart.items do |item|
  json.partial! 'api/v1/shared/item', item: item

  json.variant do
    json.partial! 'api/v1/shared/variant', variant: item.variant
  end

  json.product do
    json.partial! 'api/v1/shared/product', product: item.variant.product
  end
end
