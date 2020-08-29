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


RSpec.feature 'ユーザー情報の閲覧とアカウント削除' do
  let(:admin) { create(:admin) }
  background do
    admin.confirm
    users = build_list(:users, 100)
    users.each do |user|
      user.save
    end
  end
  
  scenario 'ページごとのユーザー数とアカウントの削除が正常に作動する' do
    login_as_admin(admin)

    expect(page).to have_content 'すべてのユーザー'
    expect(all('li').size).to eq(25)
    expect(page).to have_selector 'a', text: 'user-25'
    expect(page).not_to have_selector 'a', text: 'user-26'

    click_link 'user-25'
    expect(page).to have_selector 'h3', text: 'user-25さんのプロフィール'
    expect { click_button 'アカウントの削除' }.to change(User, :count).by(-1)
    expect(page).to have_selector 'a', text: 'user-26'

  end
end

