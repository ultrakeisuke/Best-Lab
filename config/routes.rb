Rails.application.routes.draw do
  root 'static_pages#top'
  get  '/help',    to:'static_pages#help'
  get  '/contact', to:'static_pages#contact'
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
    resources :messages, only: [:create, :destroy]
    resources :rooms, only: [:index, :show, :create]
    resources :profiles, only: [:new, :create, :edit, :update]
  end
  namespace :searches do
    resources :users, only: [:index]
    resources :questions, only: [:index] do
      collection do
        get 'get_children_categories_for_search' # 質問検索フォーム用
      end
    end
  end
  namespace :questions do
    resources :posts, only: [:index, :show, :new, :create, :edit, :update] do
      collection do
        # Ajax通信用ルーティング
        get 'get_children_categories' # 新規作成画面用
        get '/:id/get_children_categories', to:'posts#get_children_categories' # 編集画面用
      end
    end
    resources :answers, only: [:create, :update]
    resources :replies, only: [:create, :update]
    resources :categories, only: [:show]
  end
  namespace :admins do
    resources :users, only: [:index, :show, :destroy]
  end
end
