require 'rails_helper'

feature 'User authentication' do

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
  fill_in 'メールアドレス', with: 'foo@example.com'
  fill_in 'パスワード', with: 'foo123'
  fill_in '確認用パスワード', with: 'foo123'
  expect { click_button '送信'}.to change { ActionMailer::Base.deliveries.size }.by(1).and change(User, :count).by(1)
  expect(page).to have_content 'ホーム'
  expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクから登録を完了させてください。'

  # 本人確認用のメールが届かない場合
  
  # メールを再送信する
  click_link '新規登録'
  click_link '本人確認のためのメールが届かない、またはメールを紛失した方はこちら'
  expect(page).to have_content '本人確認のためのメールを送信します'
  fill_in 'メールアドレス', with: 'foo@example.com'
  expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
  expect(page).to have_content 'ログイン'
  expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡いたします。'

  # メールに記載されたURLをクリックし、ログイン画面に移行
  mail = ActionMailer::Base.deliveries.last
  url = extract_confirmation_url(mail)
  visit url
  expect(page).to have_content 'アカウント登録が完了しました。'

  # ログインに失敗
  click_link 'ログイン'
  fill_in 'メールアドレス', with: ''
  fill_in 'パスワード', with: ''
  click_button 'ログイン'
  expect(page).to have_content 'メールアドレスもしくはパスワードが正しくありません。'

  # ログインに成功
  click_link 'ログイン'
  fill_in 'メールアドレス', with: 'foo@example.com'
  fill_in 'パスワード', with: 'foo123'
  click_button 'ログイン'
  expect(page).to have_content 'ログインしました。'

  # 下記のテストはfollow, followerの関係ができた際に、改めて検証

  # another_userのプロフィール編集画面は見れないことを検証
  # expect(page).to have_content 'another_user'
  # expect(page).not_to have_content 'プロフィールの編集'

  # ユーザーのプロフィールの編集
  click_link 'プロフィール' 
  click_link 'プロフィールを編集'
  fill_in '名前', with: 'bar'
  fill_in '自己紹介', with: 'Hello World!'
  fill_in 'パスワード', with: 'foo1234'
  fill_in '確認用パスワード', with: 'foo1234'
  click_button '保存'
  expect(page).to have_content 'bar'
  expect(page).to have_content 'Hello World!'

  # ログアウト
  click_link 'ログアウト'
  expect(page).to have_content 'ログアウトしました。'

  # パスワードを忘れた場合

  # パスワード再設定メールを送信する
  # click_link 'ログイン'
  # click_link 'パスワードを忘れた方はこちら'
  # expect(page).to have_content 'パスワード再設定のためのメールを送信します'
  # fill_in 'メールアドレス', with: 'foo@example.com'
  # expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
  # expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
  # visit url
  # expect(page).to have_content '新しいパスワードを設定してください'

  end
end