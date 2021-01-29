# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  protected

    # アカウント有効化申請メール送信後はログイン画面にリダイレクトする
    def after_resending_confirmation_instructions_path_for(resource_name)
      new_user_session_path
    end

    # アカウント認証後はユーザー詳細画面にリダイレクトする
    def after_confirmation_path_for(resource_name, resource)
      users_basic_path(current_user)
    end

end
