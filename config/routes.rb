Rails.application.routes.draw do
  get 'scan/index'

  namespace :admin do
    resources :friends
    resources :goods
    resources :users
    root to: "friends#index"
  end

  # Goods routes
  resources :goods do
    member do
      get 'generate_qr'  # Route for generating QR code for a specific good
      post 'process_qr'  # Route for processing QR codes
    end
    collection do
      get 'qrcode'       # Route for QR code generation page
      post 'update_quantity' # Route for updating quantity of goods
      get 'scan'         # Route for scanning functionality
    end
  end

  # Scans routes
  resources :scans, only: [:index]

  # Devise routes
  devise_for :users# Avoid duplication
  

  # Friends routes
  resources :friends

  # Items routes
  get 'items/new'
  get 'items/create'
  get 'items/edit'
  get 'items/update'
  get 'items/destroy'
  get 'items/show'

  # Search route
  get 'search', to: "goods#search"

  # Root route
  root "items#index"

  # Health check route
  get "up" => "rails/health#show", as: :rails_health_check

  # Admin dashboard with authentication
  authenticate :user, ->(user) { user.admin? && user.email == "Destiny@Desiree.com" } do
    namespace :admin do
      Administrate::Engine.routes
    end
  end
end
