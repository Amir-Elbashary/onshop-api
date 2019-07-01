json.extract! @product, :id, :merchant_id, :category_id, :name, :description, :image, :created_at, :updated_at
json.price @product.variants.pluck(:price).sort.first
json.variants @variants, :id, :product_id, :price, :discount, :quantity, :color, :size, :image, :created_at, :updated_at
json.reviews @reviews, :id, :user_id, :product_id, :review, :rating, :created_at, :updated_at
