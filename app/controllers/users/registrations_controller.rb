# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only:[:update]
  before_action :check_guest, only: [:update, :destroy]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # アカウントの削除
  def destroy
    current_user.inactivate_account
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    yield resource if block_given?
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

    # 新規登録時のストロングパラメータを定義
    def configure_sign_up_params
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    end

    # アカウント更新時のストロングパラメータを定義
    def configure_account_update_params
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :picture])
    end

    # アカウント更新後はユーザー詳細画面にリダイレクトする
    def after_update_path_for(resource)
      users_basic_path(current_user)
    end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   users_path
    # end

    # 新規登録時はアカウント認証が完了していないので、rootにリダイレクトする
    def after_inactive_sign_up_path_for(resource)
      root_path
    end

    # パスワード入力なしでアカウント情報を更新する
    def update_resource(resource, params)
      resource.update_without_current_password(params)
    end

    # ゲストユーザーの場合は削除できないようにする
    def check_guest
      if resource.email == 'guest@example.com'
        redirect_to users_basic_path(current_user), alert: 'ゲストユーザーの編集・削除はできません。'
      end
    end

end
