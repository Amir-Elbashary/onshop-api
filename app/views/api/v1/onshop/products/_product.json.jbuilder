json.extract! product, :id, :merchant_id, :category_id, :name, :description, :image, :created_at, :updated_at
json.category_name product.category.name
json.merchant_name product.merchant.full_name
json.variants product.variants
