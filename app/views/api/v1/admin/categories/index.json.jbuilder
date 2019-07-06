if @category
  if @category.root?
    products_count = []
    @category.children.each { |c| products_count << c.products.count }

    json.category_type 'main category'
    json.products_found products_count.inject(:+)

    json.main_category do
      json.partial! 'api/v1/shared/category', category: @category
    end

    json.sub_categories do
      json.array! @category.children do |child|
        json.partial! 'api/v1/shared/category', category: child
        json.products_found child.products.count
      end
    end
  else
    json.category_type 'sub category'
    json.products_found @category.products.count

    json.sub_category do
      json.partial! 'api/v1/shared/category', category: @category
    end

    json.main_category do
      json.partial! 'api/v1/shared/category', category: @category.parent
    end
  end
else
  json.array! @categories do |category|
    json.partial! 'api/v1/shared/category', category: category
    json.sub_categories do
      json.array! category.children, partial: 'api/v1/shared/category', as: :category
    end
  end
end
