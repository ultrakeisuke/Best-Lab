require 'rails_helper'

RSpec.describe '質問の作成と編集', type: :system do
  let!(:user) { create(:user, confirmed_at: Time.current) }
  let!(:parent_category1) { create(:parent_category, name: 'parent1') }
  let!(:parent_category2) { create(:parent_category, name: 'parent2') }
  let!(:parent1_children_categories) { create_list(:children_categories, 2, ancestry: parent_category1.id) }
  let!(:parent2_children_categories) { create_list(:children_categories, 2, ancestry: parent_category2.id) }
  let!(:post) { create(:post, user_id: user.id, category_id: parent2_children_categories[1].id, title: 'title', content: 'content') }

  it '質問の新規作成におけるカテゴリーの動的変化', js: true do
    login_as_user(user)
    # 質問作成画面に移動
    visit new_questions_post_path
    # フォームの要素確認
    expect(page).to have_content '質問作成'
    expect(find('#parent_category')).to have_content parent_category1.name.to_s # 親カテゴリーの初期表示
    expect(find('#children_category')).to have_content parent1_children_categories[0].name.to_s # 子カテゴリーの初期表示
    # 親カテゴリーのセレクトボックスをクリックすると他の親カテゴリーも表示される
    find('#parent_category').click
    expect(find('#parent_category')).to have_content parent_category2.name.to_s
    # 他の親カテゴリーをクリックすると子カテゴリーの表示が変わる
    find('#parent_category').find('option:nth-child(2)').select_option
    expect(find('#children_category')).not_to have_content parent1_children_categories[0].name.to_s # 初期表示の子カテゴリーが非表示になる
    expect(find('#children_category')).to have_content parent2_children_categories[0].name.to_s # 他の子カテゴリーが表示される
  end

  it '質問の新規作成' do
    login_as_user(user)
    visit new_questions_post_path
    # 投稿に失敗する場合
    find('#post_form_title').set('')
    find('#post_form_content').set('')
    find('#post_form').click_button
    expect(page).to have_content 'タイトルが入力されていません。'
    expect(page).to have_content '質問内容が入力されていません。'
    # 投稿に成功する場合
    find('#post_form_title').set('title')
    find('#post_form_content').set('content')
    find('#post_form').click_button
    # ユーザー詳細画面に質問した投稿のタイトルが表示される
    expect(page).to have_current_path users_basic_path(user)
    expect(page).to have_content 'title'
  end

  it '質問の編集におけるカテゴリーの動的変化', js: true do
    login_as_user(user)
    # 質問編集画面に移動
    visit edit_questions_post_path(post)
    # フォームの要素確認
    expect(page).to have_content '質問編集'
    expect(find('#parent_category')).to have_content parent_category2.name.to_s # 投稿の親カテゴリーを表示
    expect(find('#children_category')).to have_content parent2_children_categories[1].name.to_s # 投稿の子カテゴリーを表示
    # 親カテゴリーのセレクトボックスをクリックすると他の親カテゴリーも表示される
    find('#parent_category').click
    expect(find('#parent_category')).to have_content parent_category1.name.to_s
    # 他の親カテゴリーをクリックすると子カテゴリーの表示が変わる
    find('#parent_category').find('option:nth-child(1)').select_option
    expect(find('#children_category')).not_to have_content parent2_children_categories[1].name.to_s # 初期表示の子カテゴリーが非表示になる
    expect(find('#children_category')).to have_content parent1_children_categories[0].name.to_s # 他の子カテゴリーが表示される
  end

  it '質問の編集' do
    login_as_user(user)
    visit questions_post_path(post)
    # 質問の詳細を確認
    expect(page).to have_content '受付中'
    expect(page).to have_content 'title'
    expect(page).to have_content 'content'
    # 質問詳細画面から編集画面に移動
    click_link '編集', match: :first
    # 投稿に失敗する場合
    find('#post_form_title').set('')
    find('#post_form_content').set('')
    find('#post_form').click_button
    expect(page).to have_content 'タイトルが入力されていません。'
    expect(page).to have_content '質問内容が入力されていません。'
    # 投稿に成功する場合
    find('#post_form_status').find('option:nth-child(2)').select_option # 「解決済」を選択
    find('#post_form_title').set('edited_title')
    find('#post_form_content').set('edited_content')
    find('#post_form').click_button
    # 編集した内容が質問詳細画面に反映される
    expect(page).to have_content '解決済'
    expect(page).to have_content 'edited_title'
    expect(page).to have_content 'edited_content'
  end
end
