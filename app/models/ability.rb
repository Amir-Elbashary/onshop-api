class Ability
  include CanCan::Ability
  MERCHANT_MODELS = [Merchant]
  MERCHANT_AUTHORIZED_MODELS = [Product, Variant, Discount]
  USER_MODELS = [User]
  USER_AUTHORIZED_MODELS = [Order, Cart, Item, Review]

  def initialize(user)
    case user
    when Admin
      # Admin can manage everything
      can :manage, :all
    when Merchant
      # Merchants have access to specific models only
      authorize_models(MERCHANT_MODELS, MERCHANT_AUTHORIZED_MODELS)
    when User
      # Users have access to specific models only
      can :favourite_product, Product
      authorize_models(USER_MODELS, USER_AUTHORIZED_MODELS)
    end
  end

  def authorize_models(user_models, target_models)
    user_models.concat(target_models).each do |model|
      can :manage, model
    end
  end
end
