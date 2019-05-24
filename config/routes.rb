Rails.application.routes.draw do
  devise_for :users
  devise_for :merchants
  devise_for :admins

  namespace :api, path: '/', defaults: { format: :json } do
    namespace :v1 do
      namespace :admin do
        resources :admins
        resources :merchants
        resources :users
        resources :app_tokens, only: :create
        resources :sessions, only: %i[create destroy]
        resources :categories
      end

      namespace :merchant do
        resources :sessions, only: %i[create destroy]
        resources :merchants
        resources :products do
          resources :variants
        end
      end

      namespace :user do
        resources :sessions, only: %i[create destroy]
        resources :users do
          collection do
            get :favourite_products
          end
        end
        resources :products do
          member do
            post :favourite_product
          end
        end
        resources :carts do
          resources :items, expect: :show
          
          collection do
            get :active_cart
          end
        end
      end

      namespace :onshop do
        resources :categories
        resources :products
      end
    end
  end
end
