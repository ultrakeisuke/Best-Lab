require 'rails_helper'

RSpec.describe 'ログインとログアウト', type: :system do
  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  let!(:admin) { create(:admin) }

  it 'ログインに失敗する' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: ''
    fill_in 'パスワード', with: ''
    click_button 'ログイン'
    expect(page).to have_current_path new_admin_session_path
  end

  it 'ログインに成功したのちログアウトする' do
    visit new_admin_session_path
    fill_in 'メールアドレス', with: admin.email
    fill_in 'パスワード', with: admin.password
    click_button 'ログイン'
    expect(page).to have_content 'ログインしました。'
    expect(page).to have_current_path root_path
    click_button 'ログアウト', match: :first
    expect(page).to have_current_path new_admin_session_path
  end
end

RSpec.describe 'ユーザー情報の閲覧とアカウント削除', js: true, type: :system do
  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }

  it '名前とメールアドレスでユーザーを検索できる' do
    login_as_admin(admin)
    # 名前でユーザー検索
    fill_in '名前', with: user.name
    fill_in 'メールアドレス', with: ''
    click_button '検索'
    expect(page).to have_content user.name
    # メールアドレスでユーザー検索
    fill_in '名前', with: ''
    fill_in 'メールアドレス', with: user.email
    click_button '検索', match: :first
    expect(page).to have_content user.name
  end

  it 'ユーザー検索とアカウント削除が正常に作動する' do
    login_as_admin(admin)
    # ユーザー検索
    fill_in 'メールアドレス', with: user.email
    click_button '検索' # 検索一覧画面に移動
    expect(page).to have_current_path admins_users_path, ignore_query: true
    click_link user.name # ユーザー詳細画面に移動
    # アカウント削除
    click_button 'アカウントの削除'
    page.accept_confirm # 確認ダイアログで「はい」を選択
    expect(page).to have_current_path admins_user_path(user)
    expect(page).to have_content '退会済みユーザー'
    expect(page).to have_content user.email
  end
end
