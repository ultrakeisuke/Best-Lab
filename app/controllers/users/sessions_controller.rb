# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # ゲストユーザーでログインするための処理
  def new_guest
    user = User.guest
    sign_in user
    redirect_to users_basic_path(user), notice: 'ゲストユーザーとしてログインしました。'
  end

  protected

    # ログイン用のストロングパラメータを定義
    def configure_sign_in_params
      devise_parameter_sanitizer.permit(:sign_in)
    end

    # ログイン後はユーザー詳細画面にリダイレクトする
    def after_sign_in_path_for(resource_name)
      users_basic_path(current_user)
    end

    # ログアウト後はrootにリダイレクトする
    def after_sign_out_path_for(resource_name)
      root_path
    end

end
