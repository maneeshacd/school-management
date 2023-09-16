Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api do
    scope :v1 do
      mount_devise_token_auth_for 'User', at: 'auth', controllers: {
        registrations:  'auth/registrations',
        sessions:  'auth/sessions'
      }
    end
  end

  root to: 'home#show'
  resources :schools do
    resources :school_admins
  end
  resources :courses do
    resources :batches
  end

  resources :batches do
    resources :enrollments
  end

  get 'classmates', to: 'students#classmates'
  get 'enrollments', to: 'enrollments#student_index'
  get 'profile', to: 'profile#show'
  get 'edit_profile', to: 'profile#edit'
  patch 'update_profile', to: 'profile#update'
  get 'home', to: 'schools#home'
  get 'home_edit', to: 'schools#home_edit'

  post '/impersonate/:id', as: :impersonate, to: 'school_admins#impersonate'
  post :stop_impersonating, to: 'school_admins#stop_impersonating'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
#
