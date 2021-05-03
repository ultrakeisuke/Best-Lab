require 'rails_helper'

RSpec.describe Searches::QuestionsController, type: :request do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: user.id, category_id: children_category.id) }

  describe 'indexアクション' do
    context 'データベースに存在しないキーワードを入力した場合' do
      it '検索結果に空を返す' do
        login_user(user)
        get searches_questions_path, params: { q: { category_id_eq: '',
                                                    content_cont_any: 'NoData NotFound' } }
        expect(response).to have_http_status '200'
        expect(response.body).to include 'お探しの質問は見つかりませんでした'
      end
    end
    context 'データベースに存在するキーワードを少なくとも1つ入力した場合' do
      it '検索結果をそのまま返す' do
        login_user(user)
        get searches_questions_path, params: { q: { category_id_eq: '',
                                                    content_cont_any: 'NoData MyString' } }
        expect(response).to have_http_status '200'
        expect(response.body).to include post.title.to_s
      end
    end
  end

  # 質問検索フォームのセレクトボックスの挙動を確認
  describe 'get_children_categories_for_searchアクション' do
    let!(:test_parent_category) { create(:parent_category) }
    let!(:test_children_category) { create(:children_category, ancestry: test_parent_category.id) }
    it '親カテゴリーを選択した際に子カテゴリーが動的に変化する' do
      login_user(user)
      get get_children_categories_for_search_searches_questions_path, xhr: true, params: { parent_category_id: test_parent_category.id }
      expect(response).to have_http_status '200'
      expect(response.body).to include test_children_category.name
    end
  end
end
