Rails.application.routes.draw do
  devise_for :admins
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      namespace :admin do
        resources :sessions, only: %i[create destroy]
      end
    end
  end
end
