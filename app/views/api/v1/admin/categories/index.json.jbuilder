if @category
  if @category.root?
    products_count = []
    @category.children.each { |c| products_count << c.products.count }

    json.category_type 'main category'
    json.products_found products_count.inject(:+)
    json.main_category @category, :id, :name_en, :name_ar, :image, :created_at, :updated_at
    json.sub_categories @category.children do |child|
      json.extract! child, :id, :parent_id, :name_en, :name_ar, :image, :created_at, :updated_at
      json.products_found child.products.count
    end
  else
    json.category_type 'sub category'
    json.products_found @category.products.count
    json.sub_category @category, :id, :parent_id, :name_en, :name_ar, :image, :created_at, :updated_at
    json.main_category @category.parent, :id, :name_en, :name_ar, :image, :created_at, :updated_at
  end
else
  json.array! @categories, partial: 'category', as: :category
end
