require 'rails_helper'

RSpec.describe Users::ProfilesController, type: :controller do
  let(:user) { create(:user) }

  describe "newアクション" do
    it "プロフィール作成画面を表示する" do
      login_user(user)
      get :new
      expect(response).to have_http_status "200"
      expect(response).to render_template :new
    end
  end

  describe "createアクション" do
    let(:profile_form) { build(:profile_form, user_id: user.id) }
    context "フォームに何も入力しなかった場合" do
      it "プロフィール作成に失敗し、作成画面を再表示する" do
        login_user(user)
        expect { post :create, params: { profile_form: { affiliation: "",
                                                         school: "",
                                                         faculty: "",
                                                         department: "",
                                                         laboratory: "",
                                                         content: "" } } }.not_to change(Profile, :count)
        expect(response).to have_http_status "200"
        expect(response).to render_template :new
      end
    end
    context "フォームに1つでも記入していた場合" do
      it "プロフィール作成に成功し、ユーザー詳細画面にリダイレクトする" do
        login_user(user)
        expect { post :create, params: { profile_form: { affiliation: profile_form.affiliation,
                                                         school: "",
                                                         faculty: "",
                                                         department: "",
                                                         laboratory: "",
                                                         content: ""  } } }.to change(Profile, :count).by(1)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user.id)
      end
    end
  end

  
  describe "editアクション" do
    let(:profile) { create(:profile, user_id: user.id) }
    it "プロフィール編集画面を表示する" do
      login_user(user)
      get :edit, params: { id: profile.id }
      expect(response).to have_http_status "200"
      expect(response).to render_template :edit
    end
  end

  describe "updateアクション" do
    let(:profile) { create(:profile, user_id: user.id) }
    context "フォームに入力した値が無効であった場合" do
      it "プロフィール編集画面を表示する" do
        login_user(user)
        # schoolカラムは最大50文字まで入力可能
        patch :update, params: { id: profile.id, profile: { affiliation: profile.affiliation,
                                                            school: "a"*51,
                                                            faculty: profile.faculty,
                                                            department: profile.department,
                                                            laboratory: profile.laboratory,
                                                            content: profile.content } }
        profile.reload
        expect(response).to have_http_status "200"
        expect(response).to render_template :edit
      end
    end
    context "フォームに入力した値が有効であった場合" do
      it "ユーザー詳細画面を表示する" do
        login_user(user)
        patch :update, params: { id: profile.id, profile: { affiliation: profile.affiliation,
                                                            school: "MySchool",
                                                            faculty: profile.faculty,
                                                            department: profile.department,
                                                            laboratory: profile.laboratory,
                                                            content: profile.content } }
        expect(profile.reload.school).to eq "MySchool"
        expect(response).to have_http_status "302"
        expect(response).to redirect_to users_basic_path(user.id)
      end
    end
  end

end
