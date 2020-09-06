require 'rails_helper'

RSpec.describe Admins::UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:admin) }

  describe "indexアクション" do
    context "ログインしていない場合" do
      it "ホーム画面にリダイレクト" do
        get :index
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_admin_session_path
      end
    end
    context "ログインしている場合" do
      it "indexページを返す" do
        sign_in admin
        get :index
        expect(response).to have_http_status "200"
        expect(response).to render_template :index
      end
    end
  end
  describe "showアクション" do
    context "ログインしていない場合" do
      it "ホーム画面にリダイレクト" do
        get :show, params: { id: user.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_admin_session_path
      end
    end
    context "ログインしている場合" do
      it "showページを返す" do
        sign_in admin
        get :show, params: { id: user.id }
        expect(response).to have_http_status "200"
        expect(response).to render_template :show
      end
    end
  end
  describe "destroyアクション" do
    context "ログインしていない場合" do
      it "ホーム画面にリダイレクト" do
        get :destroy, params: { id: user.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_admin_session_path
      end
    end
    context "ログインしている場合" do
      it "aboutページを返す" do
        sign_in admin
        get :destroy, params: { id: user.id }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to admins_users_path
      end
    end
  end

end