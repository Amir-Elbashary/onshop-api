json.extract! product, :id, :merchant_id, :category_id, :name_en, :name_ar, :description_en, :description_ar, :image, :created_at, :updated_at
json.category_name_en product.category.name_en
json.category_name_ar product.category.name_ar
json.price product.variants.pluck(:price).sort.first
json.merchant_name product.merchant.full_name
json.variants product.variants, :id, :product_id, :color_en, :color_ar, :size_en, :size_ar, :price, :discount, :quantity, :image, :created_at, :updated_at
