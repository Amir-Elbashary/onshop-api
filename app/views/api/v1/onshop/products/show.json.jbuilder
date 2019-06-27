json.extract! @product, :id, :merchant_id, :category_id, :name_en, :name_ar, :description_en, :description_ar, :image, :created_at, :updated_at
json.price @product.variants.pluck(:price).sort.first
json.variants @variants, :id, :product_id, :price, :discount, :quantity, :color_en, :color_ar, :size_en, :size_ar, :image, :created_at, :updated_at
