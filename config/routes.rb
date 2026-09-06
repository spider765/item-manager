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
<<<<<<< HEAD
    end
    collection do
      get 'qrcode'            # Route for QR code generation page
      post 'update_quantity'  # Route for updating quantity of goods
      get 'scan'              # Route for scanning functionality
      # `process_qr` moved here from `member do`: the whole point of
      # scanning is that we don't know which good it is until the QR
      # payload is decoded and parsed, so this can't depend on an :id
      # already being present in the URL. The controller looks the good
      # up itself from the decoded JSON's "id" field.
      post 'process_qr'
=======
      post 'process_qr'  # Route for processing QR codes
    end
    collection do
      get 'qrcode'       # Route for QR code generation page
      post 'update_quantity' # Route for updating quantity of goods
      get 'scan'         # Route for scanning functionality
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
    end
  end

  # Scans routes
  resources :scans, only: [:index]

  # Devise routes
<<<<<<< HEAD
  devise_for :users # Avoid duplication
=======
  devise_for :users# Avoid duplication
  
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d

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
<<<<<<< HEAD
end
=======
end
>>>>>>> 08a872e0b0666f25adddb6cc6b5370a75589913d
