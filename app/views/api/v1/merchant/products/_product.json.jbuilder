json.extract! product, :id, :merchant_id, :category_id, :name_en, :name_ar, :description_en, :description_ar, :image, :created_at, :updated_at
json.category_name product.category.name
json.variants product.variants
