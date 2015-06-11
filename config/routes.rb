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

  # Forums
  resources :forums, only: [ :index, :show ]
  # get 'forums' => 'forums#index'
  # get 'forums/:id' => 'forums#show', as: 'show_forum_path'
  ###
  
end
