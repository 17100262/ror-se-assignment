require 'sidekiq/web'
Rails.application.routes.draw do
  authenticate :user do
    mount Sidekiq::Web => '/sidekiq'
  end
  resources :blogs do
    collection do
      post 'import'
    end
  end
  resources :employees
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "blogs#index"
end
