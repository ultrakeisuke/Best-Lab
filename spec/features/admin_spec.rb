require 'rails_helper'

RSpec.feature 'ログインとログアウト' do
  background do
    admin = Admin.create!(email: 'admin@example.com', password: '1234567')
    admin.skip_confirmation!
    admin.save
  end

  scenario 'ログインに失敗する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    click_button 'ログイン'
    expect(page).to have_content 'Best-Lab'
  end

  scenario 'ログインに成功したのちログアウトする' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    click_link 'ログアウト'
    expect(page).to have_content 'Best-Lab'
  end

end

RSpec.feature 'ユーザー情報の閲覧と削除' do
  background do
    admin = Admin.create!(email: 'admin@example.com', password: '1234567')
    admin.skip_confirmation!
    admin.save
    user = User.create!(name: 'user', email: 'user@example.com', password: '123456')
    user.skip_confirmation!
    user.save
  end

  scenario 'ユーザー情報を閲覧する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'すべてのユーザー'
    click_link 'user'
    expect(page).to have_selector 'h3', text: 'userさんのプロフィール'
  end

  scenario 'ユーザー情報を削除する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: 'admin@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'すべてのユーザー'
    click_link 'user'
    expect{ click_button 'アカウントの削除' }.to change(User, :count).by(-1)
  end

end