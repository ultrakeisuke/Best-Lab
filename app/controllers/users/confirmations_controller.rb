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

  # メールによる承認完了後はログイン状態にする
  def show
    super { |resource| sign_in(resource) }
  end

  protected

    # アカウント有効化申請メール送信後はrootにリダイレクトする
    def after_resending_confirmation_instructions_path_for(resource_name)
      root_path
    end

    # アカウント認証後はユーザー詳細画面にリダイレクトする
    def after_confirmation_path_for(resource_name, resource)
      users_basic_path(current_user)
    end

end
