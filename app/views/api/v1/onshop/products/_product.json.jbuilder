json.extract! product, :id, :merchant_id, :category_id, :name, :description, :image, :created_at, :updated_at
json.category_name product.category.name
json.price product.variants.pluck(:price).sort.first
json.merchant_name product.merchant.full_name

json.variants do
  json.array! product.variants do |variant|
    json.extract! variant, :id, :product_id, :name, :color, :size, :price, :discount, :quantity, :image, :created_at, :updated_at 
    json.product_name variant.product.name
    json.category_id variant.product.category_id
    json.category_name variant.product.category.name
  end
end

