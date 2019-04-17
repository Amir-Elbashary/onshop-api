module AdminHelpers
  def assign_permission(user, action, model)
    permission = Permission.create(target_model_name: model.name, action: action)
    role = Role.create(name: Faker::Name.name, permission_ids: Permission.pluck(:id))
    user.roles << role
    user.save
  end
end
