Rails.application.routes.draw do
  devise_for :users
  devise_for :merchants
  devise_for :admins

  namespace :api, path: '/', defaults: { format: :json } do
    namespace :v1 do
      namespace :admin do
        resources :admins
        resources :app_settings, only: %i[index update]
        resources :statistics, only: :show
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
        resources :registrations, only: %i[create]
        resources :sessions, only: %i[create destroy]
        resources :reviews, except: %i[show]

        resources :users do
          collection do
            put :update_profile
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

        resources :subscriptions, only: %i[create index] do
          collection do
            post :toggle
          end
        end
      end

      namespace :onshop do
        resources :categories
        resources :products
        resources :reviews, only: %i[index show]
      end
    end
  end
end
