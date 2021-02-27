require 'rails_helper'

RSpec.describe 'アカウントに関するテスト', type: :system do

  before do
    ActionMailer::Base.deliveries.clear # テストの実行前に送信メールを空にする
    users = create_list(:test_users, 3)
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  it 'ユーザーの新規登録処理' do
    visit new_user_registration_path
    # 新規登録する
    fill_in '名前', with: 'user'
    fill_in 'メールアドレス', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    fill_in '確認用パスワード', with: 'password'
    expect { click_on '送信'}.to change { ActionMailer::Base.deliveries.size }.by(1).and change(User, :count).by(1)
    # 登録後の画面表示を確認
    expect(page).to have_current_path root_path
    expect(page).to have_content '本人確認用のメールを送信しました。メール内のリンクから登録を完了させてください。'
    # 本人確認用メールのurlをクリック
    visit_url_in_mail
    # ユーザー詳細画面に遷移したことを確認
    expect(page).to have_current_path users_basic_path(User.last)
    expect(page).to have_content 'アカウント登録が完了しました。'
    expect(page).to have_content 'アカウント設定'
    expect(page).to have_content 'プロフィール設定'
  end

  it 'アカウント有効化用のメール送信処理' do
    user = create(:another_user)
    visit new_user_registration_path
    click_on '本人確認のためのメールが届かない、またはメールを紛失した方はこちら'
    # メールを送信する
    fill_in 'メールアドレス', with: user.email
    expect { click_on '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    # メール送信後の画面表示を確認
    expect(page).to have_current_path root_path
    expect(page).to have_content 'アカウントの有効化について数分以内にメールでご連絡いたします。'
  end

end


RSpec.describe 'ログインとログアウト', type: :system do
  
  let(:user) { create(:user, confirmed_at: Time.now) }
  
  before do
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end
  
  it 'ログインとログアウト処理' do
    visit new_user_session_path
    # ログインする
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: user.password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    # ログアウトする
    click_on 'ログアウト'
    expect(page).to have_current_path root_path
  end

end


RSpec.describe 'パスワード再設定のメールを送信する', type: :system do

  let(:user) { create(:user, confirmed_at: Time.now) }

  before do
    ActionMailer::Base.deliveries.clear
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  it 'パスワード再設定メールの送信とパスワードの変更確認' do
    visit new_user_session_path
    click_on 'パスワードを忘れた方はこちら'
    # メールを送信
    fill_in 'メールアドレス', with: user.email
    expect { click_on '送信' }.to change { ActionMailer::Base.deliveries.size }.by(1)
    # メール送信後の画面表示確認
    expect(page).to have_current_path root_path
    expect(page).to have_content 'パスワードの再設定について数分以内にメールでご連絡いたします。'
    # メール内のリンクをクリック
    visit_url_in_mail
    # パスワードリセット画面でパスワードの更新
    fill_in '新しいパスワード', with: '123456'
    fill_in '確認用パスワード', with: '123456'
    click_on '保存'
    expect(page).to have_content 'パスワードが正しく変更されました。'
    # 新しいパスワードでログインできることを確認
    click_on "ログアウト"
    visit new_user_session_path
    fill_in 'メールアドレス', with: user.email
    fill_in 'パスワード', with: '123456'
    click_button "ログイン"
    expect(page).to have_content "ログインしました。"
  end

end


RSpec.describe 'アカウント情報の編集と削除', type: :system do

  let(:user) { create(:user, confirmed_at: Time.now) }

  before do
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  it 'アカウント情報の編集と削除処理' do
    login_as_user(user)
    click_link 'アカウント設定'
    # アカウントを編集
    fill_in '名前', with: 'user!'
    attach_file 'プロフィール画像', "#{Rails.root}/spec/factories/images/rails.png"
    click_on '保存'
    # 編集後の画面表示を確認
    expect(page).to have_current_path users_basic_path(user)
    expect(page).to have_content 'user!'
    expect(page).to have_selector "img[src$='rails.png']"
    # アカウント削除
    click_link 'アカウント設定'
    click_on 'アカウントの削除'
    page.accept_confirm # 確認ダイアログで「はい」を選択
    expect(page).to have_current_path root_path
    expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"
  end

end


RSpec.describe 'ゲストログインとアカウント削除', type: :system do

  before do
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  it 'ゲストユーザーのアカウントを編集・削除できない' do
    visit root_path
    click_on 'ゲストログイン(閲覧用)'
    # ゲストログイン後の画面表示確認
    expect(page).to have_content 'ゲストユーザーでログインしました。'
    # アカウントを編集
    click_link 'アカウント設定'
    fill_in '名前', with: 'another_user'
    click_on '保存'
    # アカウントを編集できないことを確認
    expect(page).to have_content "ゲストユーザーの編集・削除はできません。"
    # アカウントを削除
    click_link 'アカウント設定'
    click_on 'アカウントの削除'
    page.accept_confirm # 確認ダイアログで「はい」を選択
    # アカウントを削除できないことを確認
    expect(page).to have_content "ゲストユーザーの編集・削除はできません。"
  end

end
