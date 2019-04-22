Rails.application.routes.draw do
  devise_for :merchants
  devise_for :admins
  namespace :api, path: '/', defaults: { format: :json } do
    namespace :v1 do
      namespace :admin do
        resources :app_tokens, only: :create
        resources :sessions, only: %i[create destroy]
        resources :categories
        resources :merchants
      end
    end
  end
end
