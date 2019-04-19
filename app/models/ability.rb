class Ability
  include CanCan::Ability
  # MERCHANT_MODELS = []
  # MERCHANT_AUTHORIZED_MODELS = []
  # USER_MODELS = []
  # USER_AUTHORIZED_MODELS = []

  def initialize(user)
    case user
    when Admin
      # Admin can manage everything
      can :manage, :all
    # when Merchant
    #   # Users have access to specific models only
    #   authorize_models(MERCHANT_MODELS, MERCHANT_AUTHORIZED_MODELS)
    # when User
    #   # Users have access to specific models only
    #   authorize_models(USER_MODELS, USER_AUTHORIZED_MODELS)
    # end
  end

  # def authorize_models(user_models, target_models)
  #   user_models.concat(target_models).each do |model|
  #     can :manage, model
  #   end
  # end
end
