require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { create(:user) }
  let(:guest_user) { create(:guest_user) }

  describe "createアクション" do
    context "新規登録に失敗した場合" do
      it "新規登録画面にレンダリングする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, params: { user: { name: "", email: "", password: "", password_confirmation: "" } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "新規登録成功した場合" do
      it "ログイン画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, params: { user: { name: "user", email: "user@example.com", password: "1234567", password_confirmation: "1234567" } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
  describe "updateアクション" do
    context "プロフィール編集に失敗した場合" do
      it "プロフィール編集画面にレンダリングする" do
        login_user(user)
        put :update, params: { user: { profile: "1"*201 } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
    context "プロフィール編集に成功した場合" do
      it "プロフィール画面にリダイレクトする" do
        login_user(user)
        put :update, params: { user: { profile: "1"*200 } }
        expect(user.reload.profile).to eq "1"*200
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to users_profile_path(user)
      end
    end
  end
  describe "destroyアクション" do
    context "ユーザーを削除しようとした場合" do
      it "ユーザーが削除され、プロフィール画面にリダイレクトする" do
        login_user(user)
        expect{ delete :destroy }.to change(User, :count).by(-1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to about_path
      end
    end
    context "ゲストユーザーを削除しようとした場合" do
      it "ゲストユーザーは削除されず、プロフィール画面にリダイレクトする" do
        login_user(guest_user)
        expect{ delete :destroy }.not_to change(User, :count)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_profile_path(guest_user)
      end
    end
  end
end