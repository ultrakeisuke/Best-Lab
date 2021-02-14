require 'rails_helper'

RSpec.describe Admins::UsersController, type: :controller do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }
  let!(:parent_category) { create(:parent_category) }
  let!(:children_category) { create(:children_category, ancestry: parent_category.id) }

  describe "showアクション" do
    context "DBに存在しないユーザーのidを入力した場合" do
      it "rootにリダイレクトする" do
        login_admin(admin)
        get :show, params: { id: 0 }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
    context "DBに存在するユーザーのidを入力した場合" do
      it "ユーザー詳細画面を表示する" do
        login_admin(admin)
        get :show, params: { id: user }
        expect(response).to have_http_status "200"
        expect(response).to render_template :show
      end
    end
  end

  describe "destroyアクション" do
    context "DBに存在しないユーザーを削除しようとした場合" do
      it "削除に失敗し、rootにリダイレクトする" do
        login_admin(admin)
        delete :destroy, params: { id: 0 }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
    context "DBに存在するユーザーを削除しようとした場合" do
      it "削除に成功し、ユーザー詳細画面にリダイレクトする" do
        login_admin(admin)
        delete :destroy, params: { id: user }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to admins_user_path(user)
      end
    end
  end
end
