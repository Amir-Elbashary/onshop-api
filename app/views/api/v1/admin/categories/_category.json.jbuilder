json.extract! category, :id, :name_en, :name_ar, :image, :created_at, :updated_at
json.sub_categories category.children
