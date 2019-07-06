json.extract! product, :id, :merchant_id, :category_id,
                       :name, :name_en, :name_ar,
                       :description, :description_en, :description_ar,
                       :image, :created_at, :updated_at
json.category_name product.category.name
json.price product.variants.pluck(:price).sort.first
json.merchant_name product.merchant.full_name
