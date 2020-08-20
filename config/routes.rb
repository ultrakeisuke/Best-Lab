Rails.application.routes.draw do
  root 'homes#index'
  get  '/help',    to:'homes#help'
  get  '/about',   to:'homes#about'
  get  '/contact', to:'homes#contact'
  devise_for :admins, :controllers => {
    :sessions      => 'admins/sessions'
  }
  devise_for :users, :controllers => {
    :confirmations => 'users/confirmations',
    :passwords     => 'users/passwords',
    :registrations => 'users/registrations',
    :sessions      => 'users/sessions'
  }
  devise_scope :user do
    get    "sign_in",  to:"users/sessions#new"
    delete "sign_out", to:"users/sessions#destroy"
  end
   resources :users, only: [:show]
   namespace :admins do
    resources :users, only: [:index, :show]
   end
end
