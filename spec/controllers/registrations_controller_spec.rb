require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
  let(:user) { create(:user) }

  describe "createアクション" do
    context "新規登録に失敗した場合" do
      it "新規登録画面にレンダリングする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, params: { user: { name: "", email: "", password: "", passwor_confirmation: "" } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "新規登録に成功した場合" do
      it "ホーム画面にリダイレクトされる" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        post :create, params: { user: { name: "user1", email: "user1@example.com",
                                        password: "1234567", password_confirmation: "1234567" } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "updateアクション" do
    context "プロフィール編集に失敗した場合" do
      it "プロフィール編集画面にレンダリングする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        sign_in user
        put :update, params: { user: { profile: "1"*201 } }
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
    context "プロフィール編集に成功した場合" do
      it "プロフィール画面にリダイレクトする" do
        @request.env["devise.mapping"] = Devise.mappings[:user]
        user.confirm
        sign_in user
        put :update, params: { user: { profile: "1"*200 } }
        expect(user.reload.profile).to eq "1"*200
        expect(response).to have_http_status "302"
        expect(assigns(:user)).to eq user
        expect(response).to redirect_to user_path(user)
      end
    end
  end

end