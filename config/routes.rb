Rails.application.routes.draw do

  # Devise
  devise_scope :user do

    # Using `scope` for a shortcut
    scope '/users' do
      post 'resend_code' => 'users/registrations#resend_code'
      post 'verify_code' => 'users/registrations#verify_code'
    end
  end
  
  devise_for :users, controllers: {
               registrations: 'users/registrations'
             }
  ###

  # Home
  root 'home#index'
  get 'dashboard' => 'home#dashboard'
  get 'about' => 'home#about'
  ###

  resources :forums, only: [ :index, :show ] do
    collection do
      get :search
    end
    
    member do
      get :children
    end

    resources :posts, only: [ :index, :show, :new, :create ] do
      resources :comments, only: [ :create ]
    end
  end
end
