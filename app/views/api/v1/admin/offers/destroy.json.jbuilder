json.array! @categories do |category|
  json.partial! 'api/v1/shared/offer', offer: category.offer
end
