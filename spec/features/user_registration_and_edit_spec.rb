require 'rails_helper'

feature 'User registration and edit' do

  # テストの実行前に送信メールを空にする
  background do
    ActionMailer::Base.deliveries.clear
  end

  # 送信したメールからパスワード設定画面のURLを抽出する
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario 'ユーザーの新規登録とプロフィールの編集' do
  visit root_path
  expect(page).to have_http_status :ok

  # ユーザーを新規登録する

  # ユーザーの新規登録に失敗
  click_link '新規登録'
  fill_in '名前', with: ''
  fill_in 'メールアドレス', with: ''
  fill_in 'パスワード', with: ''
  fill_in '確認用パスワード', with: ''
  expect { click_button '送信'}.not_to change(User, :count)

  # ユーザーの新規登録に成功
  click_link '新規登録'
  fill_in '名前', with: 'foo'
  fill_in 'メールアドレス', with: 'foo@test.com'
  fill_in 'パスワード', with: 'foo123'
  fill_in '確認用パスワード', with: 'foo123'
  expect { click_button '送信'}.to change { ActionMailer::Base.deliveries.size }.by(1).and change(User, :count).by(1)
  expect(page).to have_content '登録いただいたメールアドレスにアカウント有効化のためのメールを送信しました。メール内のリンクから有効化を完了してください。'

  # メールに記載されたURLをクリックし、ログイン画面に移行
  mail = ActionMailer::Base.deliveries.last
  url = extract_confirmation_url(mail)
  visit url
  expect(page).to have_content 'ログイン'

  # userでログインする
  click_link 'ログイン'
  fill_in 'メールアドレス', with: 'foo@test.com'
  fill_in 'パスワード', with: 'foo123'
  click_button 'ログイン'
  expect(page).to have_content 'ログインしました。'

  # another_userのプロフィール編集画面は見れないことを検証
  # expect(page).to have_content 'another_user'
  # expect(page).not_to have_content 'プロフィールの編集'

  # userのプロフィールを編集
  click_link 'プロフィール' 
  click_link 'プロフィールを編集'
  fill_in '名前', with: 'foo!'
  fill_in 'メールアドレス', with: 'foo@test.com'
  fill_in '現在のパスワード', with: 'foo123'
  click_button '送信'
  end
end