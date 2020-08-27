module LoginMacros
  def login(user)
    visit sign_in_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
  end

  def logout
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。'
  end
end