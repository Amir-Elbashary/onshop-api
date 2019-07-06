json.extract! variant, :id, :product_id,
                       :name, :name_en, :name_ar,
                       :color, :color_en, :color_ar,
                       :size, :size_en, :size_ar,
                       :price, :discount, :quantity,
                       :image, :created_at, :updated_at 
json.product_name variant.product.name
json.category_id variant.product.category_id
json.category_name variant.product.category.name
