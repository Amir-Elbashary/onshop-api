class Api::V1::User::ContactsController < Api::V1::User::BaseUserController
  skip_authorization_check
  skip_before_action :authenticate_user

  swagger_controller :contacts, 'User'

  swagger_api :create do
    summary 'Sending message to support (Contact us)'
    param :header, 'X-APP-Token', :string, :required, 'App Authentication Token'
    param :form, 'contact[user_name]', :string, :required, 'Full Name'
    param :form, 'contact[email]', :email, :required, 'User Email'
    param :form, 'contact[phone_number]', :string, :optional, 'Phone Number'
    param :form, 'contact[message]', :text, :required, 'Message'
    response :created
    response :unprocessable_entity
    response :unauthorized
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.save
      render json: @contact, status: :created
    else
      render json: { errors: @contact.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def contact_params
    params.require(:contact).permit(:user_name, :email, :phone_number, :message)
  end
end
