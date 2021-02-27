require 'rails_helper'

RSpec.describe Admins::UsersController, type: :request do
  let!(:user) { create(:user) }
  let!(:admin) { create(:admin) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe 'showアクション' do
    context 'DBに存在しないユーザーのidを入力した場合' do
      it 'rootにリダイレクトする' do
        login_admin(admin)
        get admins_user_path(-1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end
    context 'DBに存在するユーザーのidを入力した場合' do
      it 'ユーザー詳細画面を表示する' do
        login_admin(admin)
        get admins_user_path(user)
        expect(response).to have_http_status '200'
      end
    end
  end

  describe 'destroyアクション' do
    context 'DBに存在しないユーザーを削除しようとした場合' do
      it '削除に失敗し、rootにリダイレクトする' do
        login_admin(admin)
        delete admins_user_path(-1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end
    context 'DBに存在するユーザーを削除しようとした場合' do
      it '削除に成功し、ユーザー詳細画面にリダイレクトする' do
        login_admin(admin)
        delete admins_user_path(user)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to admins_user_path(user)
      end
    end
  end
end
