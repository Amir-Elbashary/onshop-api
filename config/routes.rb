Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
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
        resources :faqs
        resources :offers
        resources :coupons

        resources :orders, only: %i[index show] do
          member do
            post :confirm
          end
        end

        resources :contacts, only: %i[index show] do
          member do
            post :toggle
          end
        end

        resources :subscriptions, only: %i[index destroy] do
          member do
            post :toggle
          end
        end
      end

      namespace :merchant do
        resources :sessions, only: %i[create destroy]
        resources :merchants
        resources :discounts

        resources :products do
          resources :variants
        end
      end

      namespace :user do
        resources :sessions, only: %i[create destroy]
        resources :reviews, except: :show
        resources :contacts, only: :create

        resources :orders do
          member do
            post :coupon
            post :checkout
          end
        end

        resources :registrations, only: :create do
          collection do
            post :social_media
          end
        end

        resources :users do
          collection do
            put :update_profile
            get :orders
            get :favourite_products
            post :clear_favourites
          end
        end

        resources :products do
          member do
            get :is_favourite
            post :favourite_product
          end
        end

        resources :carts do
          resources :items, expect: :show

          member do
            post :clear
          end

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
        resources :app_settings, only: :index
        resources :categories
        resources :products
        resources :reviews, only: %i[index show]
        resources :faqs, only: :index
      end
    end
  end
end
