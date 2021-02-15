require 'rails_helper'

RSpec.describe Questions::CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:posts) { 3.times.collect { |i| create(:post, category_id: children_category.id, user_id: user.id) } }

  describe 'showアクション' do
    context "DBに存在するカテゴリーidを入力した場合" do
      it "カテゴリーごとの質問一覧画面を表示する" do
        login_user(user)
        get :show, params: { id: children_category.id }
        expect(response).to have_http_status "200"
        expect(response).to render_template :show
        expect(assigns(:posts)).to eq posts.reverse
      end
    end
    context "DBに存在しないカテゴリーidを入力した場合" do
      it "rootにリダイレクトする" do
        login_user(user)
        get :show, params: { id: 10000000 }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
  end

end
