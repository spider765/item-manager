Rails.application.routes.draw do
<<<<<<< HEAD
  get 'scan/index'
  namespace :admin do
      resources :friends
      resources :goods
      resources :users

      root to: "friends#index"
    end

    # config/routes.rb
resources :goods do
  member do
    get 'generate_qr'  # Adds the route for generate_qr
    post 'process_qr'
  end
  collection do
    get 'qrcode'  # Adds the 'qrcode' route for goods
 post 'update_quantity', to: 'goods#update_quantity', as: 'update_quantity'
       get 'scan'
  end
end
post '/goods/process_qr', to: 'goods#process_qr'

# config/routes.rb


  devise_for :users
  resources :friends
  resources :scans, only: [:index]
=======
  devise_for :users
  resources :goods
  resources :friends
>>>>>>> 6b8a898766600ddf024c5fe77c0f32253f4e97c9

  get 'items/new'
  get 'items/create'
  get 'items/edit'
  get 'items/update'
  get 'items/destroy'
  get 'items/show'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "items#index"
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
<<<<<<< HEAD
 get 'search', to:"goods#search"
  # Defines the root path route ("/")
  # root "posts#index"

  authenticate :user, ->(user) { user.admin? && user.email == "Destiny@Desiree.com" } do
  namespace :admin do
    Administrate::Engine.routes
  end
end

=======
 get 'search', to:"goods#search" 
  # Defines the root path route ("/")
  # root "posts#index"
>>>>>>> 6b8a898766600ddf024c5fe77c0f32253f4e97c9
end
