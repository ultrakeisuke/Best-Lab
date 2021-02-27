require 'rails_helper'

RSpec.describe Searches::UsersController, type: :request do
  let(:user) { create(:user) }
  let!(:profile) { create(:profile, user_id: user.id) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

  describe "contentカラムに複数のキーワードを入力したときの挙動について" do
    context "データベースに存在しないキーワードを入力した場合" do
      it "リクエストが成功し、該当ユーザーなしの検索結果を返す" do
        login_user(user)
        get searches_users_path, params: { q: { affiliation_eq: "",
                                                school_eq: "",
                                                faculty_eq: "",
                                                department_eq: "",
                                                laboratory_eq: "",
                                                description_cont_any: "NoData NotFound" } }
        expect(response).to have_http_status "200"
        expect(response.body).to include "お探しのユーザーは見つかりませんでした"
      end
    end
    context "データベースに存在するキーワードを少なくとも1つ入力した場合" do
      it "リクエストが成功し検索結果を返す" do
        login_user(user)
        get searches_users_path, params: { q: { affiliation_eq: "",
                                                school_eq: "",
                                                faculty_eq: "",
                                                department_eq: "",
                                                laboratory_eq: "",
                                                content_cont_any: "NoData MyString" } }
        expect(response).to have_http_status "200"
        expect(response.body).to include "#{profile.user.name}"
      end
    end
  end

end
