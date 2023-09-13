Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: { registrations: 'users/registrations' }

  root to: 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
end
#
