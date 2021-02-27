require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :request do

  let(:user) { create(:user) }
  let(:guest_user) { create(:guest_user) }

  before do
    parent_category = create(:parent_category)
    children_category = create(:children_category, ancestry: parent_category.id)
  end

  describe "createアクション" do
    context "新規登録に失敗した場合" do
      it "新規登録画面にレンダリングする" do
        post user_registration_path, params: { user: { name: "", email: "", password: "", password_confirmation: "" } }
        expect(response).to have_http_status "200"
      end
    end
    context "新規登録成功した場合" do
      it "ログイン画面にリダイレクトする" do
        post user_registration_path, params: { user: { name: "user", email: "user@example.com", password: "1234567", password_confirmation: "1234567" } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
  end
  describe "updateアクション" do
    context "プロフィール編集に失敗した場合" do
      it "プロフィール編集画面にレンダリングする" do
        login_user(user)
        put user_registration_path, params: { user: { name: "1"*51 } }
        expect(response).to have_http_status "200"
      end
    end
    context "プロフィール編集に成功した場合" do
      it "プロフィール画面にリダイレクトする" do
        login_user(user)
        put user_registration_path, params: { user: { name: "1"*50 } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user)
      end
    end
  end
  describe "destroyアクション" do
    context "ユーザーを削除しようとした場合" do
      it "ユーザーが削除され、トップ画面にリダイレクトする" do
        login_user(user)
        expect{ delete user_registration_path }.not_to change(User, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
    context "ゲストユーザーを削除しようとした場合" do
      it "ゲストユーザーは削除されず、プロフィール画面にリダイレクトする" do
        login_user(guest_user)
        expect{ delete user_registration_path }.not_to change(User, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(guest_user)
      end
    end
  end
end
