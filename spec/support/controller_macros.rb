module ControllerMacros

  # 管理者としてログイン
  def login_admin(admin)
    sign_in admin
  end

  # 一般ユーザーとしてログイン
  def login_user(user)
    user.confirm
    sign_in user
  end

end
