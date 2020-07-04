Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/help', to:'static_pages#help'
  get  '/about', to:'static_pages#about'
  get  '/contact', to:'static_pages#contact'
  devise_for :users, :controllers => {
    :registrations => 'users/registrations',
    :sessions => 'users/sessions'
  }
  devise_scope :user do
    get "sign_in", to:"users/sessions#new"
    get "sign_out", to:"users/sessions#destroy"
  end
  get  'users/:id', to:'users#show'
end
