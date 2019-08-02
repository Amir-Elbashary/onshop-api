if @favourite_product
  json.favourite true
else
  json.favourite false
end

json.product do
  json.partial! 'api/v1/shared/product', product: @product
end
