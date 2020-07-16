# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController

  def new
    super
  end

  def create
    super
  end

  def show
    # confirmation_tokenをメール受信者が持っていれば、そのトークンからユーザーを検索する
    self.resource = resource_class.find_by_confirmation_token(params[:confirmation_token]) if params[:confirmation_token].present?
    # 
    super if resource.nil? or resource.confirmed?
  end

  def confirm
    confirmation_token = params[resource_name][:confirmation_token] # メールのURLからトークンを取り出す
    self.resource = resource_class.find_by_confirmation_token!(confirmation_token) # そのトークンからユーザーを検索
    if resource.update(confirm_params) && resource.password_match? # 入力したパスワードと確認用が合致する場合
      self.resource = resource_class.confirm_by_token(confirmation_token) # 認証を完了する
      set_flash_message :notice, :confirmed 
      sign_in_and_redirect(resource_name, resource) # ログインしてユーザーページ(今はホーム)に遷移する
    else
      render :action => "show"
    end
  end

  private

    def confirm_params
      params.require(resource_name).permit(:password, :password_confirmation)
    end


  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end
end
