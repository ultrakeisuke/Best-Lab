require 'rails_helper'

RSpec.feature 'ユーザーの新規登録' do

  # テストの実行前に送信メールを空にする
  background do
    ActionMailer::Base.deliveries.clear
  end

  scenario '新規登録に失敗する' do
    visit root_path
    find('a.sign-up').click
    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    fill_in '確認用パスワード', with: ''
    expect { click_button '送信'}.not_to change(User, :count)
  end

  scenario '新規登録に成功する' do
    visit root_path
    find('a.sign-up').click
    fill_in '名前', with: 'user'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: '1234567'
    fill_in '確認用パスワード', with: '1234567'
    expect { click_button '送信'}.to change { ActionMailer::Base.deliveries.size }.by(1).and change(User, :count).by(1)

    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクから登録を完了させてください。'

    visit_url_in_mail
    expect(page).to have_content 'アカウント登録が完了しました。'
  end

end

RSpec.feature '登録完了のメールを再送信する' do
  let(:user) { create(:user) }
  background do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'メールの送信に失敗する' do
    visit root_path
    find('a.sign-up').click
    click_link '本人確認のためのメールが届かない、またはメールを紛失した方はこちら'
    fill_in 'メールアドレス', with: ''
    click_button '送信'
    expect(page).to have_selector '#error_explanation', text:'メールアドレスが入力されていません。'
  end
  
  scenario 'メールの送信に成功するし、アカウントを有効化する' do
    visit root_path
    find('a.sign-up').click
    click_link '本人確認のためのメールが届かない、またはメールを紛失した方はこちら'
    fill_in 'メールアドレス', with: user.email
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)

    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡いたします。'

    visit_url_in_mail
    expect(page).to have_content 'アカウント登録が完了しました。'
  end
end


RSpec.feature 'ログインとログアウト' do
  let(:user) { create(:user) }
  background do
    user.confirm
  end

  scenario 'ログインに失敗する' do
    visit root_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    click_button 'ログイン'
    expect(page).to have_content 'Best-Lab'
  end

  scenario 'ログインに成功し、ログアウトする' do
    visit root_path
    click_link 'ログイン'
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    click_link 'ログアウト'
    expect(page).to have_content 'Best-Lab'
  end

end


RSpec.feature 'パスワード再設定のメールを送信する' do
  let(:user) { create(:user) }
  background do
    ActionMailer::Base.deliveries.clear
  end

  scenario 'メールの送信に失敗する' do
    visit root_path
    click_link 'ログイン'
    click_link 'パスワードを忘れた方はこちら'
    fill_in 'メールアドレス', with: ''
    click_button '送信'
    expect(page).to have_selector '#error_explanation', text:'メールアドレスが入力されていません。'
  end

  scenario 'メールの送信に成功し、パスワードを変更する' do
    visit root_path
    click_link 'ログイン'
    click_link 'パスワードを忘れた方はこちら'
    fill_in 'メールアドレス', with: user.email
    expect { click_button '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)

    expect(page).to have_current_path '/users/sign_in'
    expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'

    visit_url_in_mail

    fill_in '新しいパスワード', with: '123456'
    fill_in '確認用パスワード', with: '123456'
    click_button '保存'
    expect(page).to have_content 'パスワードが正しく変更されました。'
  end
end


RSpec.feature 'プロフィールの編集とアカウント削除' do
  let(:user) { create(:user) }
  background do
    user.confirm
  end

  scenario 'プロフィールの編集に失敗する' do
    login_as_user(user)
    click_link 'プロフィール' 
    click_link 'プロフィールを編集'
    fill_in '名前', with: ''
    click_button '保存'
    expect(page).to have_selector '#error_explanation', text:'名前が入力されていません。'
  end

  scenario 'プロフィールの編集に成功したのちアカウントを削除する' do
    login_as_user(user)
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

    click_link 'プロフィールを編集'
    expect { click_button 'アカウントの削除'}.to change(User, :count).by(-1)
    expect(page).to have_current_path root_path
  end

end