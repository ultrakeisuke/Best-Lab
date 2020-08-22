require 'rails_helper'

RSpec.feature 'ログインとログアウト' do
  background do
    admin = Admin.create!(email: 'admin@example.com', password: '1234567')
    admin.skip_confirmation!
    admin.save
  end

  scenario 'ログインに失敗する' do
    visit new_admin_session_path
    expect(page).to have_http_status :ok
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    click_button 'ログイン'
    expect(page).to have_content 'メールアドレスもしくはパスワードが正しくありません。'
  end

  scenario 'ログインに成功したのちログアウトする' do
    visit new_admin_session_path
    expect(page).to have_http_status :ok
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    click_link 'ログアウト'
    expect(page).to have_content 'ログアウトしました。'
  end

end