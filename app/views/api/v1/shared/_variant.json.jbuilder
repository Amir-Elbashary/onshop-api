json.extract! variant, :id, :product_id,
                       :name, :name_en, :name_ar,
                       :color, :color_en, :color_ar,
                       :size, :size_en, :size_ar,
                       :quantity, :image,
                       :created_at, :updated_at 
json.product_name variant.product.name
json.category_id variant.product.category_id
json.category_name variant.product.category.name

offer = variant.product.category.offer
discount = variant.product.discount

if offer && offer.active?
  json.price variant.price - (variant.price * offer.percentage / 100)
  json.old_price variant.price
elsif discount && discount.active?
  json.price variant.price - (variant.price * discount.percentage / 100)
  json.old_price variant.price
else
  json.price variant.price
  json.old_price variant.price
end


