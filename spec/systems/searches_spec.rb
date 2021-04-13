require 'rails_helper'

RSpec.describe 'プロフィール検索', type: :system do
  let(:user) { create(:user, confirmed_at: Time.current) }
  let!(:profile) { create(:profile, user_id: user.id) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  it 'プロフィールをもとにユーザーを検索する' do
    login_as_user(user)
    visit users_basic_path(user)
    # 存在しないユーザーを検索する
    find('#q_affiliation_eq').find("option[value='graduate']").select_option
    find('#profile_search').click_button '検索'
    expect(page).to have_content 'お探しのユーザーは見つかりませんでした。'
    # 存在するユーザーを検索する
    find('#q_affiliation_eq').find("option[value='#{user.profile.affiliation}']").select_option
    fill_in 'プロフィール・研究分野など', with: 'My String'
    find('#profile_search').click_button '検索'
    expect(page).to have_current_path searches_users_path, ignore_query: true # 検索結果画面を返す
    expect(page).to have_content user.name # 目的のユーザーが表示される
  end
end

RSpec.describe '質問検索', type: :system do
  let(:user) { create(:user, confirmed_at: Time.current) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: user.id, category_id: children_category.id) }
  let!(:children_categories) { create_list(:children_categories, 3, ancestry: parent_category.id) }

  it 'カテゴリーとキーワードをもとに質問を検索する' do
    login_as_user(user)
    visit users_basic_path(user)
    # 存在しない質問を検索
    find('#parent_category_for_search').find("option[value='#{parent_category.id}']").select_option
    find('#children_category_for_search').find("option[value='#{children_categories[0].id}']").select_option
    find('#post_search').click_button '検索'
    expect(page).to have_content 'お探しの質問は見つかりませんでした。'
    # 存在する質問を検索
    find('#parent_category_for_search').find("option[value='#{post.category.parent.id}']").select_option
    find('#children_category_for_search').find("option[value='#{post.category_id}']").select_option
    fill_in 'キーワード', with: 'My String'
    find('#post_search').click_button '検索'
    expect(page).to have_current_path searches_questions_path, ignore_query: true # 検索結果画面を返す
    expect(page).to have_content post.title # 目的の質問が表示される
  end
end
