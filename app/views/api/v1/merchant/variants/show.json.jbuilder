json.variant @variant, :id, :product_id, :name_en, :name_ar, :color_en, :color_ar, :size_en, :size_ar, :price, :discount, :quantity, :image, :created_at, :updated_at

json.product do
  json.extract! @product, :id, :merchant_id, :category_id, :name_en, :name_ar, :description_en, :description_ar, :image, :created_at, :updated_at
  json.category_name_en @product.category.name_en
  json.category_name_ar @product.category.name_ar
end
