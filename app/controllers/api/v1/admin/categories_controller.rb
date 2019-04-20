class Api::V1::Admin::CategoriesController < Api::V1::Admin::BaseAdminController

  swagger_controller :categories, 'Admin'

  swagger_api :create do
    summary 'Create new categories and sub categories'
    notes "
      <h4>This APIs creates categories and sub_categories as following:</h4>
      <p>Enter ONE parent_category like 'electronics' (Downcase is recommended)</p>
      <p>Enter one or multiple sub_categories sperated by comma only like 'computers,phone,laptops' (Downcase is recommended)</p>
      <p>API by default ignores the existing parent categories so it won't be duplicated</p>
      <p>while is ignores the existing sub categories for the parent category, so sub category can be entered with same name UNDER A DIFFERENT parent category</p>
    "
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :parent_category, :string, :required, 'Parent Categories'
    param :query, :sub_categories, :string, :optional, 'Sub Categories'
    response :ok
    response :unauthorized
    response :unprocessable_entity
  end

  def create
    return render json: { error: 'parent category must exist' }, status: :unprocessable_entity if params[:parent_category].blank?
    return render json: { error: 'only 1 parent category is allowed per call' }, status: :unprocessable_entity if params[:parent_category].split(',').count > 1

    new_parent = false

    parent_category = Category.where("lower(categories.name) = '#{params[:parent_category].downcase.strip.squeeze}'").first

    if parent_category
      new_parent = false
      current_category_children = parent_category.children
    end

    unless parent_category
      new_parent = true
      parent_category = Category.create(name: params[:parent_category].downcase.strip.squeeze)
    end

    new_children = params[:sub_categories].split(',') if params[:sub_categories].present?

    added_children = 0
    existing_children = 0

    if new_children
      new_children.map do |child|
        if parent_category.children.where("lower(categories.name) = '#{child.downcase.strip.squeeze}'").any?
          existing_children += 1 
          next
        end

        Category.create(name: child.downcase.strip.squeeze, parent: parent_category)
        added_children += 1
      end
    end

    render json: { summary: "#{new_parent ? 'new parent category created' : 'parent category already exists'}, #{added_children} new sub categories added, #{existing_children} existing sub categories ignored", parent_category: parent_category, sub_categories: parent_category.children }, status: :ok
  end
end
