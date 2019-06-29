json.extract! category, :id, :name, :image, :created_at, :updated_at

products_count = []
category.children.each { |c| products_count << c.products.count }

json.products products_count.inject(:+)

json.sub_categories category.children do |child|
  json.extract! child, :id, :name, :image, :created_at, :updated_at
  json.products child.products.count
end
