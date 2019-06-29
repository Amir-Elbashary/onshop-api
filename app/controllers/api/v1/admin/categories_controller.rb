class Api::V1::Admin::CategoriesController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_category, only: %i[index update destroy]

  swagger_controller :categories, 'Admin'

  swagger_api :index do
    summary 'Listing categories'
    notes "
      <h4>This API lists categories and sub_categories as following:</h4>
      <p>Enter locale to get the corresponding language, Available locales: en, ar</p>
      <p>If locale left blank, Default english locale will be used</p>
      <p>Enter an ID of a category and you'll have response with it's type and info</p>
      <p>Leave ID blank if you want list of all categories</p>
    "
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :loc, :string, 'Locale'
    param :query, :id, :string, 'Category ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def index
    @categories = Category.roots unless params[:id]
  end

  swagger_api :create do
    summary 'Create new categories and sub categories'
    notes "
      <h4>This API creates categories and sub_categories as following:</h4>
      <p>Enter ONE parent_category like 'electronics' (Downcase is recommended)</p>
      <p>Enter one or multiple sub_categories sperated by comma only</p>
      <p>Example: 'computers,phone,laptops' (Downcase is recommended)</p>
      <p>API by default ignores the existing parent categories so it won't be duplicated</p>
      <p>while is ignores the existing sub categories for the parent category,</p>
      <p>so sub category can be entered with same name UNDER A DIFFERENT parent category</p>
    "
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :parent_category, :string, :required, 'Parent Categories'
    param :query, :sub_categories, :string, :optional, 'Sub Categories'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def create
    # Performing essential checks
    return render json: { error: 'parent category must exist' }, status: :unprocessable_entity if params[:parent_category].blank?
    return render json: { error: 'only 1 parent category is allowed per call' }, status: :unprocessable_entity if params[:parent_category].split(',').count > 1

    # Initialize values to be used as results
    new_parent = false
    added_children = 0
    existing_children = 0

    # Checking for parent category existance (find or create)
    parent_category = Category.with_translations(:en).where('lower(category_translations.name) = ?', "#{params[:parent_category].downcase.strip.squeeze}").first

    new_parent = false if parent_category

    unless parent_category
      new_parent = true
      parent_category = Category.create(name: params[:parent_category].downcase.strip.squeeze)
    end

    # Checking for sub categories (as children)
    new_children = params[:sub_categories].split(',') if params[:sub_categories].present?

    new_children&.map do |child|
      valid_child = true

      parent_category.children.each do |category|
        if category.translations.where('lower(category_translations.name) = ?', "#{child.downcase.strip.squeeze}").any?
          existing_children += 1
          valid_child = false
          break
        end
      end

      next if valid_child == false

      Category.create(name: child.downcase.strip.squeeze, parent: parent_category)
      added_children += 1
    end

    # Responding with results
    render json: { summary: "#{new_parent ? 'new parent category created' : 'parent category already exists'}, "\
                            "#{added_children} new sub categories added, "\
                            "#{existing_children} existing ignored",
                   parent_category: parent_category,
                   sub_categories: parent_category.children }, status: :ok
  end

  swagger_api :update do
    summary 'Edit categories info'
    notes "
      <h4>This API updates categories information</h4>
    "
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Category ID'
    param :query, :name, :string, :required, 'Category Name'
    param :query, :name_ar, :string, :required, 'Category Arabic Name'
    response :ok
    response :unauthorized
    response :unprocessable_entity
    response :not_found
  end

  def update
    if params[:name].present?
      @existing_category = Category.find_by(name: params[:name].downcase.strip.squeeze)

      if @category == @existing_category
        if @category.update(name_en: params[:name].downcase.strip.squeeze, name_ar: params[:name_ar], image: params[:image])
          return render json: { message: 'category info updated' }, status: :ok
        end
      end

      # In case we have a parent category
      if @category.root?
        if @existing_category && @existing_category.root?
          if Category.with_translations.where('category_translations.name = ?', @existing_category.name).any?
            return render json: { error: 'parent category with same name already exists' }, status: :unprocessable_entity
          end
        else
          if @category.update(name_en: params[:name].downcase.strip.squeeze, name_ar: params[:name_ar], image: params[:image])
            render json: { message: 'category info updated' }, status: :ok
          else
            render json: @category.errors.full_messages, status: :unprocessable_entity
          end
        end
      end

      # In case we have a sub category
      unless @category.root?
        child_exists = false

        @category.parent.children.each do |child|
          if child.translations.where('category_translations.name = ?', "#{params[:name].downcase.strip.squeeze}").any?
            child_exists = true
            break
          end
        end

        if child_exists == true
          return render json: { error: 'sub category with same name already exists within it\'s parent category' }, status: :unprocessable_entity
        else
          if @category.update(name_en: params[:name].downcase.strip.squeeze, name_ar: params[:name_ar], image: params[:image])
            render json: { message: 'category info updated' }, status: :ok
          else
            render json: @category.errors.full_messages, status: :unprocessable_entity
          end
        end
      end
    else
      render json: { error: 'unique category name is required' }, status: :unprocessable_entity
    end
  end

  swagger_api :destroy do
    summary 'Delete categories'
    notes "
      <h4>This API deletes categories</h4>
    "
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Category ID'
    response :ok
    response :unauthorized
    response :not_found
  end

  def destroy
    return render json: { error: 'unknown error occured' }, status: :unprocessable_entity unless @category.destroy
    render json: { message: 'category was deleted' }, status: :ok
  end

  private

  def set_category
    @category = Category.find(params[:id]) if params[:id]
  end
end
