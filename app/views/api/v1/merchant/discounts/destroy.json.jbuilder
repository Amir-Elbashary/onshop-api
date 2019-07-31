json.array! @products do |product|
  json.partial! 'api/v1/shared/discount', discount: product.discount
end
