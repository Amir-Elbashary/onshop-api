class Api::V1::Admin::ContactsController < Api::V1::Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_contact, only: %i[show toggle]

  swagger_controller :contacts, 'Admin'

  swagger_api :index do
    summary 'Listing user contacting messages'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :query, :filter, :string, :required, '(open/opened), (close/closed), or all'
    param :query, :page, :integer, :optional, 'Page'
    response :ok
    response :unauthorized
  end

  def index
    @contacts =  if ['open', 'opened'].include?(params[:filter].downcase.strip)
                   Contact.open.page(params[:page]).per_page(32)
                 elsif ['close', 'closed'].include?(params[:filter].downcase.strip)
                   Contact.close.page(params[:page]).per_page(32)
                 else
                   Contact.all.page(params[:page]).per_page(32)
                 end
  end

  swagger_api :show do
    summary 'Showing contact data'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Contact ID'
    response :ok
    response :not_found
    response :unauthorized
  end

  def show; end

  swagger_api :toggle do
    summary 'Toggling contact status'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :header, 'X-User-Token', :string, :required, 'Admin Authentication Token'
    param :path, :id, :integer, :required, 'Contact ID'
    response :ok
    response :not_found
    response :unauthorized
  end

  def toggle
    if @contact.open?
      @contact.close!
    else
      @contact.open!
    end

    render json: { id: @contact.id, status: @contact.status }, status: :ok
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end
end
