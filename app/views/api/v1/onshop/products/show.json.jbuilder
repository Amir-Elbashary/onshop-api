json.extract! @product, :id, :merchant_id, :category_id, :name, :description, :image, :created_at, :updated_at
json.price @product.variants.pluck(:price).sort.first

json.variants do
  json.array! @product.variants do |variant|
    json.extract! variant, :id, :product_id, :name, :color, :size, :price, :discount, :quantity, :image, :created_at, :updated_at 
    json.product_name variant.product.name
    json.category_id variant.product.category_id
    json.category_name variant.product.category.name
  end
end

json.reviews do
  json.array! @reviews do |review|
    json.extract! review, :id, :user_id, :product_id, :review, :rating, :created_at, :updated_at
    json.user_name review.user.full_name
  end
end

json.related_product do
  json.array! @related_products, partial: 'product', as: :product
end
