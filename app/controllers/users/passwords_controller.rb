# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  before_action :check_guest, only: [:create]
  
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  protected

    # パスワード再設定後はユーザー詳細ページにリダイレクトする
    def after_resetting_password_path_for(resource)
      users_basic_path(current_user)
    end
  
    # パスワード再設定メール送信後はrootにリダイレクトする
    def after_sending_reset_password_instructions_path_for(resource_name)
      root_path
    end

    # ゲストユーザーはパスワード変更のメールを送れず、変更もできない
    def check_guest
      if params[:user][:email] == "guest@example.com"
        redirect_to new_user_password_path, alert: 'ゲストユーザーのパスワードは変更できません。'
      end
    end

end
