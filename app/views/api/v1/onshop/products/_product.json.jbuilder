json.extract! product, :id, :merchant_id, :category_id, :name, :description, :image, :created_at, :updated_at
json.category_name product.category.name
json.price product.variants.pluck(:price).sort.first
json.merchant_name product.merchant.full_name
json.variants product.variants, :id, :product_id, :color, :size, :price, :discount, :quantity, :image, :created_at, :updated_at
