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
        # カテゴリーを選択した際のセレクトボックスの動的処理
        get 'get_children_categories_for_search' # 質問検索フォーム用
      end
    end
  end
  namespace :questions do
    resources :posts, only: [:index, :show, :new, :create, :edit, :update] do
      member do
        # ベストアンサーを選出する処理
        patch 'select_best_answer'
      end
      collection do
        # カテゴリーを選択した際のセレクトボックスの動的処理
        get 'get_children_categories' # 質問の投稿・編集画面用
      end
    end
    resources :answers, only: [:create, :update]
    resources :replies, only: [:create, :update]
    resources :categories, only: [:show]
  end
  namespace :admins do
    resources :users, only: [:index, :show, :destroy] # indexは検索結果画面
    resources :posts, only: [:show, :destroy]
  end
end
