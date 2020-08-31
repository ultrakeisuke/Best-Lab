Rails.application.routes.draw do
  root 'homes#top'
  get  '/help',    to:'homes#help'
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
    get    'sign_in',  to:'users/sessions#new'
    delete 'sign_out', to:'users/sessions#destroy'
    post   'users/guest_sign_in', to: 'users/sessions#new_guest'
  end
  namespace :users do
    resources :basics, only: [:index, :show]
  end
  namespace :admins do
    resources :users, only: [:index, :show, :destroy]
  end
end
