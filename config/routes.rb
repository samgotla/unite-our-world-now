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

  # Admin
  scope '/admin' do
    get 'user_search' => 'admin#user_search'
  end
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
      get :all_posts
    end

    resources :posts, only: [ :index, :show, :new, :create ] do
      post :upvote
      post :downvote
      
      resources :comments, only: [ :create ] do
        post :upvote
        post :downvote
      end
    end
  end
end
