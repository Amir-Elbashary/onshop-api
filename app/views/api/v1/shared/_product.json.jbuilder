json.extract! product, :id, :merchant_id, :category_id,
                       :name, :name_en, :name_ar,
                       :description, :description_en, :description_ar,
                       :image, :created_at, :updated_at
json.category_name product.category.name

lowest_price = product.variants.pluck(:price).sort.first

if lowest_price
  offer = product.category.offer
  discount = product.discount

  if offer && offer.active?
    json.price lowest_price - (lowest_price * offer.percentage / 100)
    json.old_price lowest_price
  elsif discount && discount.active?
    json.price lowest_price - (lowest_price * discount.percentage / 100)
    json.old_price lowest_price
  else
    json.price lowest_price
    json.old_price lowest_price
  end
end

json.merchant_name product.merchant.full_name
