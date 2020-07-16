require 'rails_helper'

feature 'Sign up' do

  # テストの実行前に送信メールを空にする
  background do
    ActionMailer::Base.deliveries.clear
  end

  # 送信したメールからパスワード設定画面のURLを抽出する
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario 'メールアドレスのみでユーザー登録し、パスワードを後から設定する' do
  visit root_path
  expect(page).to have_http_status :ok

  click_link '新規登録'
  fill_in '名前', with: 'foo'
  fill_in 'メールアドレス', with: 'foo@example.com'
  expect { click_button '送信'}.to change { ActionMailer::Base.deliveries.size }.by(1)
  expect(page).to have_content '登録いただいたメールアドレスに本登録用のメールを送信しました。メール内のリンクからアカウントを有効化してください。'

  mail = ActionMailer::Base.deliveries.last
  url = extract_confirmation_url(mail)
  visit url
  expect(page).to have_content 'パスワードを登録してください。'

  # 登録に失敗する場合
  # 何も入力せずに送信ボタンをクリック
  click_button '送信'
  # 画面にエラ〜メッセージが表示されることを検証
  expect(page).to have_content "パスワードを入力してください。"
  expect(page).to have_content "確認用パスワードを入力してください。"

  # 一致しない確認パスワードを入力する
  fill_in 'パスワード', with: '1234567'
  fill_in '確認用パスワード', with: '12345678'
  # 送信ボタンをクリック
  click_button '送信'
  # 画面にエラ〜メッセージが表示されることを検証
  expect(page).to have_content '確認用パスワードが間違っています。'

  # 登録に成功する場合
  fill_in 'パスワード', with: '1234567'
  fill_in '確認用パスワード', with: '1234567'
  # 送信ボタンをクリック
  click_button '送信'
  # パスワードの設定が正常に完了したことを検証する
  expect(page).to have_content 'アカウントを登録しました'

  # Log outリンクをクリック
  click_link 'ログアウト'
  # ログアウトのメッセージが表示されていることを確認する
  expect(page).to have_content 'ログアウトしました。'

  # Log inリンクをクリック
  click_link 'ログイン'
  # メールアドレスを入力
  fill_in 'メールアドレス', with: 'foo@example.com'
  # パスワードを入力
  fill_in 'パスワード', with: '1234567'
  # ログインボタンをクリック
  click_button 'ログイン'
  # ログイン成功のメッセージが表示されていることを検証
  expect(page).to have_content 'ログインしました。'

  end
end