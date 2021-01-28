require 'rails_helper'

RSpec.describe Searches::QuestionsController, type: :controller do
  let(:user) { create(:user) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }
  let!(:post) { create(:post, user_id: user.id, category_id: children_category.id) }

  describe "contentカラムに複数のキーワードを入力したときの挙動について" do
    context "データベースに存在しないキーワードを入力した場合" do
      it "検索結果に空を返す" do
        login_user(user)
        get :index, params: { q: { category_id_eq: "",
                                   content_cont_any: "NoData NotFound" } }
        expect(assigns(:posts)).to eq []
      end
    end
    context "データベースに存在するキーワードを少なくとも1つ入力した場合" do
      it "検索結果をそのまま返す" do
        login_user(user)
        get :index, params: { q: { category_id_eq: "",
                                   content_cont_any: "NoData MyString" } }
        expect(assigns(:posts)).to include post
      end
    end
  end
end