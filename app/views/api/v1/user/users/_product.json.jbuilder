json.extract! product, :id, :category_id, :name, :description, :image, :created_at, :updated_at
json.price product.variants.pluck(:price).sort.first
