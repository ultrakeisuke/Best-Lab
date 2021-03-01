require 'rails_helper'

RSpec.describe Users::BasicsController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe 'showアクション' do
    context 'ユーザー詳細画面に入ろうとした場合' do
      it '正常なレスポンスを返す' do
        login_user(user)
        get users_basic_path(another_user)
        expect(response).to have_http_status '200'
      end
    end
    context 'DBに存在しないユーザーの詳細画面に入ろうとした場合' do
      it 'rootにリダイレクトする' do
        login_user(user)
        get users_basic_path(-1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end
    context '退会済みのユーザー詳細画面に入ろうとした場合' do
      let(:discarded_user) { create(:another_user, discarded_at: Time.current) }
      it 'rootにリダイレクトする' do
        login_user(user)
        get users_basic_path(discarded_user)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end
  end
end
