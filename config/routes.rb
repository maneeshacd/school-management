Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }

  namespace :api do
    devise_for :users, defaults: { format: :json },
                     class_name: 'ApiUser',
                           skip: [:registrations, :invitations,
                                  :passwords, :confirmations,
                                  :unlocks],
                           path: '',
                     path_names: { sign_in: 'login',
                                  sign_out: 'logout' }
    devise_scope :user do
      get 'login', to: 'devise/sessions#new'
      delete 'logout', to: 'devise/sessions#destroy'
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

  resources :students, only: [:index, :show]

  get '/batches/:id/classmates', to: 'students#classmates', as: :batch_classmates
  get 'enrollments', to: 'enrollments#student_index'
  get '/enrollments/pending', to: 'enrollments#pending', as: :pending_enrollments
  get 'profile', to: 'profile#show'
  get 'edit_profile', to: 'profile#edit'
  patch 'update_profile', to: 'profile#update'
  get 'home', to: 'schools#home'
  get 'home_edit', to: 'schools#home_edit'
  post '/enrollments/admin_create', to: 'enrollments#admin_create', as: :admin_create

  post '/impersonate/:id', as: :impersonate, to: 'school_admins#impersonate'
  post :stop_impersonating, to: 'school_admins#stop_impersonating'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
#
