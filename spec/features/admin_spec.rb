require 'rails_helper'

RSpec.feature 'ログインとログアウト' do
  let(:admin) { create(:admin) }
  background do
    admin.confirm
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
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    click_link 'ログアウト'
    expect(page).to have_content 'Best-Lab'
  end

end

RSpec.feature 'ユーザー情報の閲覧と削除' do
  let(:admin) { create(:admin) }
  let(:user) { create(:user) }
  background do
    admin.confirm
    user.confirm
  end

  scenario 'ユーザー情報を閲覧する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'すべてのユーザー'
    click_link 'user'
    expect(page).to have_selector 'h3', text: 'userさんのプロフィール'
  end

  scenario 'ユーザーアカウントを削除する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'すべてのユーザー'
    click_link 'user'
    expect{ click_button 'アカウントの削除' }.to change(User, :count).by(-1)
  end

end


RSpec.feature 'ページネーション表示' do
  let(:admin) { create(:admin) }
  background do
    admin.confirm
    users = build_list(:users, 200, confirmed_at: Time.current, created_at: Time.current, updated_at: Time.current)
    users.each do |user|
      user.save
    end
  end
  
  scenario 'ページごとのユーザー数とページネーションリンクを正常に表示する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'

    expect(all('li').size).to eq(25)
    expect(page).to have_selector 'a', text: '次'
    expect(page).to have_selector 'a', text: '最後'
    expect(page).to have_content '...'
    
    click_link '最後'
    expect(page).to have_content '...'
    expect(page).to have_selector 'a', text: '最初'
    expect(page).to have_selector 'a', text: '前'
  end
end

