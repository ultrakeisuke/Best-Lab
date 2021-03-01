require 'rails_helper'

RSpec.describe Users::ProfilesController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:guest_user) { create(:guest_user) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe 'newアクション' do
    it 'プロフィール作成画面を表示する' do
      login_user(user)
      get new_users_profile_path
      expect(response).to have_http_status '200'
    end
  end

  describe 'createアクション' do
    let(:profile_form) { build(:profile_form, user_id: user.id) }
    context 'フォームに何も入力しなかった場合' do
      it 'プロフィール作成に失敗し、作成画面を再表示する' do
        login_user(user)
        expect do
          post users_profiles_path, params: { profile_form: { affiliation: '',
                                                              school: '',
                                                              faculty: '',
                                                              department: '',
                                                              laboratory: '',
                                                              description: '' } }
        end.not_to change(Profile, :count)
        expect(response).to have_http_status '200'
      end
    end
    context 'affiliationカラムに入力した値が指定した値以外だった場合' do
      # affiliationカラムは大学生、大学院生、高専生、専門学生、社会人、その他のみ保存可能
      it 'プロフィール作成に失敗し、作成画面を再表示する' do
        login_user(user)
        expect do
          post users_profiles_path, params: { profile_form: { affiliation: 'undergraduate!',
                                                              school: '',
                                                              faculty: '',
                                                              department: '',
                                                              laboratory: '',
                                                              description: '' } }
        end.not_to change(Profile, :count)
        expect(response).to have_http_status '200'
      end
    end
    context 'フォームに有効な値を入力していた場合' do
      it 'プロフィール作成に成功し、ユーザー詳細画面にリダイレクトする' do
        login_user(user)
        expect do
          post users_profiles_path, params: { profile_form: { affiliation: profile_form.affiliation,
                                                              school: profile_form.school,
                                                              faculty: profile_form.faculty,
                                                              department: profile_form.department,
                                                              laboratory: profile_form.laboratory,
                                                              description: profile_form.description } }
        end.to change(Profile, :count).by(1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
  end

  describe 'editアクション' do
    let(:profile) { create(:profile, user_id: user.id) }
    let(:another_profile) { create(:profile, user_id: another_user.id) }
    context '他人のプロフィール編集画面に入ろうとした場合' do
      it 'ログインユーザーの詳細画面にリダイレクトする' do
        login_user(user)
        get edit_users_profile_path(another_profile)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context '自分のプロフィール編集画面に入ろうとした場合' do
      it 'プロフィール編集画面を表示する' do
        login_user(user)
        get edit_users_profile_path(profile)
        expect(response).to have_http_status '200'
      end
    end
  end

  describe 'updateアクション' do
    let(:profile) { create(:profile, user_id: user.id) }
    let(:another_profile) { create(:profile, user_id: another_user.id) }
    let(:guest_profile) { create(:profile, user_id: guest_user.id) }
    let(:profile_form) { build(:profile_form, user_id: user.id) }
    context 'フォームに何も入力しなかった場合' do
      it 'プロフィール編集画面を表示する' do
        login_user(user)
        patch users_profile_path(profile), params: { profile_form: { affiliation: '',
                                                                     school: '',
                                                                     faculty: '',
                                                                     department: '',
                                                                     laboratory: '',
                                                                     description: '' } }
        profile.reload
        expect(response).to have_http_status '200'
      end
    end
    context 'affiliationカラムに入力した値が指定した値以外だった場合' do
      it 'プロフィール編集に失敗し、作成画面を再表示する' do
        login_user(user)
        patch users_profile_path(profile), params: { profile_form: { affiliation: 'undergraduate!',
                                                                     school: '',
                                                                     faculty: '',
                                                                     department: '',
                                                                     laboratory: '',
                                                                     description: '' } }
        expect(response).to have_http_status '200'
      end
    end
    context '他人のプロフィールを編集しようとした場合' do
      it 'プロフィール編集に失敗し、ログインユーザーの詳細画面にリダイレクトする' do
        login_user(user)
        patch users_profile_path(guest_profile), params: { profile_form: { affiliation: profile_form.affiliation,
                                                                           school: profile_form.school,
                                                                           faculty: profile_form.faculty,
                                                                           department: profile_form.department,
                                                                           laboratory: profile_form.laboratory,
                                                                           description: profile_form.description } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context 'ゲストユーザーのプロフィールを編集しようとした場合' do
      it 'プロフィール編集に失敗し、ユーザーの詳細画面にリダイレクトする' do
        login_user(guest_user)
        patch users_profile_path(guest_profile), params: { profile_form: { affiliation: profile_form.affiliation,
                                                                           school: profile_form.school,
                                                                           faculty: profile_form.faculty,
                                                                           department: profile_form.department,
                                                                           laboratory: profile_form.laboratory,
                                                                           description: profile_form.description } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(guest_user)
      end
    end
    context 'フォームに入力した値が有効であった場合' do
      it 'ユーザー詳細画面を表示する' do
        login_user(user)
        patch users_profile_path(profile), params: { profile_form: { affiliation: profile_form.affiliation,
                                                                     school: 'MySchool',
                                                                     faculty: profile_form.faculty,
                                                                     department: profile_form.department,
                                                                     laboratory: profile_form.laboratory,
                                                                     description: profile_form.description } }
        expect(profile.reload.school).to eq 'MySchool'
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
  end
end
