require 'rails_helper'

RSpec.describe Users::PasswordsController, type: :request do
  let(:user) { create(:user, confirmed_at: Time.now) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe 'createアクション' do
    context 'パスワード変更のメール送信に失敗する場合' do
      it 'メール送信画面にレンダリングする' do
        post user_password_path, params: { user: { email: '' } }
        expect(response).to have_http_status '200'
      end
    end
    context 'ゲストユーザーのパスワード変更メールを送信しようとした場合' do
      let!(:guest) { create(:guest_user, confirmed_at: Time.now) }
      it 'メール送信画面にレンダリングする' do
        post user_password_path, params: { user: { email: guest.email } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to new_user_password_path
      end
    end
    context 'パスワード変更のメール送信に成功する場合' do
      it 'ログイン画面にリダイレクトする' do
        post user_password_path, params: { user: { email: user.email } }
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end
  end

  describe 'updateアクション' do
    context 'パスワード再設定に失敗する場合' do
      it 'パスワード入力画面にレンダリングする' do
        put user_password_path, params: { user: { password: '', password_confirmation: '' } }
        expect(response).to have_http_status '200'
      end
    end
    context 'パスワード再設定に成功する場合' do
      it 'ホーム画面にリダイレクトする' do
        raw = user.send_reset_password_instructions
        put user_password_path, params: { user: { reset_password_token: raw, password: '12345678', password_confirmation: '12345678' } }
        user.reload
        expect(user.valid_password?('12345678')).to eq(true)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
  end
end
