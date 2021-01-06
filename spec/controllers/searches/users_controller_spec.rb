require 'rails_helper'

RSpec.describe Searches::UsersController, type: :controller do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user_id: user.id) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

  describe "contentカラムに複数のキーワードを入力したときの挙動について" do
    context "データベースに存在しないキーワードを入力した場合" do
      it "検索結果に空を返す" do
        login_user(user)
        get :index, params: { q: { affiliation_eq: "",
                                   school_eq: "",
                                   faculty_eq: "",
                                   department_eq: "",
                                   laboratory_eq: "",
                                   content_cont_any: "NoData NotFound" } }
        expect(assigns(:profiles)).to eq []
      end
    end
    context "データベースに存在するキーワードを少なくとも1つ入力した場合" do
      it "検索結果をそのまま返す" do
        login_user(user)
        get :index, params: { q: { affiliation_eq: "",
                                   school_eq: "",
                                   faculty_eq: "",
                                   department_eq: "",
                                   laboratory_eq: "",
                                   content_cont_any: "NoData MyString" } }
        expect(assigns(:profiles)).to include profile
      end
    end
  end

end
