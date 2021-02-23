module LoginMacros

  # 一般ユーザーのログイン
  def login_as_user(user)
    visit sign_in_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
  end

  # 管理者のログイン
  def login_as_admin(admin)
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    click_button 'ログイン'
  end

end
