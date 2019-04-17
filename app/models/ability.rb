class Ability
  include CanCan::Ability
  AUTHORIZED_MODELS = []
  # MODEL_MODELS = []
  # MODEL_AUTHORIZED_MODELS = []

  def initialize(user)
    case user
    when Admin
      # Admin can manage everything
      can :manage, :all
    # when OTHER MODEL
    #   # Supervisor can manage anything he has access on.
    #   user.roles.each do |role|
    #     role.permissions.each do |permission|
    #       model = permission.target_model_name.constantize
    #       can permission.action.to_sym, model
    #     end
    #   end
    # when User
    #   # Users have access to specific models only
    #   authorize_models(USERS_MODELS, USERS_AUTHORIZED_MODELS)
    end
  end

  # def authorize_models(user_models, target_models)
  #   user_models.concat(target_models).each do |model|
  #     can :manage, model
  #   end
  # end
end
