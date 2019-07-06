if @category
  products_count = []
  @category.children.each { |c| products_count << c.products.count }
  json.products products_count.inject(:+)

  json.partial! 'api/v1/shared/category', category: @category

  json.sub_categories @category.children do |child|
    json.partial! 'api/v1/shared/category', category: child
    json.products child.products.count
  end
else
  json.array! @categories do |category|
    products_count = []
    category.children.each { |c| products_count << c.products.count }
    json.products products_count.inject(:+)

    json.partial! 'api/v1/shared/category', category: category

    json.sub_categories category.children do |child|
      json.partial! 'api/v1/shared/category', category: child
      json.products child.products.count
    end
  end
end
