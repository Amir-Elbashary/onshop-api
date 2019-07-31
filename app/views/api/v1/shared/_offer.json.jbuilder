json.extract! offer, :id, :category_id, :percentage, :starts_at, :ends_at, :created_at, :updated_at
json.category_name offer.category.name
json.category_name_en offer.category.name_en
json.category_name_ar offer.category.name_ar
