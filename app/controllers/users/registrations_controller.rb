# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_user!, only: [:edit, :update, :destroy]
  before_action :admin_user, only: :destroy

  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end

  def update
    super
  end

  def destroy
    super
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

  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: add_attr)
  # end

  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: add_attr)
  # end

  def after_update_path_for(resource)
    user_path(id: current_user.id)
  end

  # def after_sign_up_path_for(resource)
  #   users_path
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  # 管理者だけがユーザーを削除できる
  def admin_user
    redirect_to root_url unless current_user.admin?
  end

end
