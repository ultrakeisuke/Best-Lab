require 'rails_helper'

RSpec.feature 'ユーザーの新規登録' do

  # テストの実行前に送信メールを空にする
  background do
    ActionMailer::Base.deliveries.clear
  end

  # 送信したメールからパスワード設定画面のURLを抽出する
  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario '新規登録に失敗する' do
    visit about_path
    find('a.sign-up').click
    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    fill_in '確認用パスワード', with: ''
    expect { click_button '送信'}.not_to change(User, :count)
  end

  scenario '新規登録に成功する' do
    visit about_path
    find('a.sign-up').click
    fill_in '名前', with: 'user'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: '1234567'
    fill_in '確認用パスワード', with: '1234567'
    expect { click_button '送信'}.to change { ActionMailer::Base.deliveries.size }.by(1).and change(User, :count).by(1)
    # expect(page).to have_current_path '/about'
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクから登録を完了させてください。'

    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content 'アカウント登録が完了しました。'
  end

end

RSpec.feature '登録完了のメールを再送信する' do
  background do
    ActionMailer::Base.deliveries.clear
    user = User.create!(name: 'user', email: 'user@example.com', password: '1234567')
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario 'メールの送信に失敗する' do
    visit about_path
    find('a.sign-up').click
    click_link '本人確認のためのメールが届かない、またはメールを紛失した方はこちら'
    fill_in 'メールアドレス', with: ''
    click_button '送信'
    expect(page).to have_selector '#error_explanation', text:'メールアドレスが入力されていません。'
  end
  
  scenario 'メールの送信に成功するし、アカウントを有効化する' do
    visit about_path
    find('a.sign-up').click
    click_link '本人確認のためのメールが届かない、またはメールを紛失した方はこちら'
    fill_in 'メールアドレス', with: 'user@example.com'
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'ログイン'
    expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡いたします。'
    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    expect(page).to have_content 'アカウント登録が完了しました。'
  end
end


RSpec.feature 'ログインとログアウト' do
  background do
    user = User.create!(name: 'user', email: 'user@example.com', password: '1234567')
    user.skip_confirmation!
    user.save
  end

  scenario 'ログインに失敗する' do
    visit about_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    click_button 'ログイン'
    expect(page).to have_content 'Best-Lab'
  end

  scenario 'ログインに成功し、ログアウトする' do
    visit about_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    click_link 'ログアウト'
    expect(page).to have_content 'Best-Lab'
  end

end


RSpec.feature 'パスワード再設定のメールを送信する' do
  background do
    ActionMailer::Base.deliveries.clear
    user = User.create!(name: 'user', email: 'user@example.com', password: '1234567')
  end

  def extract_confirmation_url(mail)
    body = mail.body.encoded
    body[/http[^"]+/]
  end

  scenario 'メールの送信に失敗する' do
    visit about_path
    click_link 'ログイン'
    click_link 'パスワードを忘れた方はこちら'
    fill_in 'メールアドレス', with: ''
    click_button '送信'
    expect(page).to have_selector '#error_explanation', text:'メールアドレスが入力されていません。'
  end

  scenario 'メールの送信に成功し、パスワードを変更する' do
    visit about_path
    click_link 'ログイン'
    click_link 'パスワードを忘れた方はこちら'
    fill_in 'メールアドレス', with: 'user@example.com'
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
    mail = ActionMailer::Base.deliveries.last
    url = extract_confirmation_url(mail)
    visit url
    fill_in '新しいパスワード', with: '123456'
    fill_in '確認用パスワード', with: '123456'
    click_button '保存'
    expect(page).to have_content 'パスワードが正しく変更されました。'
  end
end


RSpec.feature 'プロフィールの編集' do
  background do
    user = User.create!(name: 'user', email: 'user@example.com', affiliation: 0 , password: '1234567')
    user.skip_confirmation!
    user.save
  end

  scenario 'プロフィールの編集に失敗する' do
    visit about_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    # 上記はmacrosファイルに定義しておく
    click_link 'プロフィール' 
    click_link 'プロフィールを編集'
    fill_in '名前', with: ''
    click_button '保存'
    expect(page).to have_selector '#error_explanation', text:'名前が入力されていません。'
  end

  scenario 'プロフィールの編集に成功する' do
    visit about_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: '1234567'
    click_button 'ログイン'
    # 上記はmacrosファイルに定義しておく
    click_link 'プロフィール' 
    click_link 'プロフィールを編集'

    click_link '戻る'
    click_link 'プロフィールを編集'
    
    fill_in '名前', with: 'user!'
    fill_in 'メールアドレス', with: 'user123@example.com'
    find('input[id=user_affiliation_graduate]').click # ラジオボタンで大学院生を選択
    fill_in '自己紹介', with: 'Hello World!'
    fill_in 'パスワード', with: '123456'
    fill_in '確認用パスワード', with: '123456'
    click_button '保存'
    expect(page).to have_content 'user!'
    expect(page).to have_content 'Hello World!'
    expect(page).to have_content '大学院生'
  end

end