require 'rails_helper'

feature 'User picture' do  
  let(:user) { create(:user) }

  before do
    user.confirm
  end

  scenario '画像アップロード' do
  visit root_path
  expect(page).to have_http_status :ok

  # ログインに成功
  click_link 'ログイン'
  fill_in 'メールアドレス', with: 'user@example.com'
  fill_in 'パスワード', with: '1234567'
  click_button 'ログイン'
  expect(page).to have_content 'ログインしました。'

  # ユーザーのプロフィールの編集
  click_link 'プロフィール'
  click_link 'プロフィールを編集'
  attach_file 'プロフィール画像', "#{Rails.root}/spec/factories/images/rails.png"
  click_button '保存'
  expect(page).to have_selector("img[src$='#{Time.now.strftime('%Y%m%d%H%M%S') + '.jpg'}']")
  
  end
end