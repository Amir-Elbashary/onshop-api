if @category
  variants_count = []

  @category.children.each do |child|
    child.products.each { |product| variants_count << product.variants.count }
  end

  json.variants variants_count.inject(:+).to_i
  json.partial! 'api/v1/shared/category', category: @category

  json.sub_categories @category.children do |child|
    variants_count = []
    child.products.each { |product| variants_count << product.variants.count }

    json.variants variants_count.inject(:+).to_i
    json.partial! 'api/v1/shared/category', category: child
  end
else
  json.array! @categories do |category|
    variants_count = []

    category.children.each do |child|
      child.products.each { |product| variants_count << product.variants.count }
    end

    json.variants variants_count.inject(:+).to_i
    json.partial! 'api/v1/shared/category', category: category

    json.sub_categories category.children do |child|
      variants_count = []
      child.products.each { |product| variants_count << product.variants.count }

      json.variants variants_count.inject(:+).to_i
      json.partial! 'api/v1/shared/category', category: child
    end
  end
end
