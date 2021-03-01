require 'rails_helper'

RSpec.describe Users::SessionsController, type: :request do
  let(:user) { create(:user, confirmed_at: Time.current) }
  let(:guest_user) { create(:guest_user, confirmed_at: Time.current) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe 'newアクション' do
    it '正常なレスポンスを返す' do
      get user_session_path
      expect(response).to have_http_status '200'
      expect(response).to render_template :new
    end
  end

  describe 'createアクション' do
    context 'ログインに失敗した場合' do
      it 'ログイン画面を表示する' do
        post user_session_path, params: { user: { email: '', password: '' } }
        expect(response).to have_http_status '200'
      end
    end
    context 'ログインに成功した場合' do
      it 'ユーザー詳細画面にリダイレクトする' do
        post user_session_path, params: { user: { email: user.email, password: user.password } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
    context 'ゲストユーザーでログインした場合' do
      it 'ユーザー詳細画面にリダイレクトする' do
        post users_guest_sign_in_path, params: { user: { name: guest_user.name, email: guest_user.email } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(guest_user)
      end
    end
    context '退会済みのユーザーがログインしようとした場合' do
      let!(:discarded_user) { create(:another_user, discarded_at: Time.current) }
      it '新規登録画面にリダイレクトする' do
        post user_session_path, params: { user: { email: discarded_user.email, password: discarded_user.password } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to new_user_registration_path
      end
    end
  end

  describe 'destroyアクション' do
    it '正常なレスポンスを返す' do
      delete destroy_user_session_path
      expect(response).to have_http_status '302'
      expect(response).to redirect_to root_path
    end
  end
end
