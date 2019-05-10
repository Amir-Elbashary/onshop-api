json.extract! category, :id, :name, :image, :created_at, :updated_at
json.sub_categories category.children
