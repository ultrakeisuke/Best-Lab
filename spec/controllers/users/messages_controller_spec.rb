require 'rails_helper'

RSpec.describe Users::MessagesController, type: :request do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:room) { create(:room) }
  let!(:user_entry) { create(:entry, user_id: user.id, room_id: room.id) }
  let!(:another_entry) { create(:entry, user_id: another_user.id, room_id: room.id) }

  before do
    parent_category = create(:parent_category)
    create(:children_category, ancestry: parent_category.id)
  end

  describe 'createアクション' do
    context 'メッセージ文も画像も空だった場合' do
      it 'メッセージは保存されず、メッセージ画面にリダイレクトする' do
        login_user(user)
        expect do
          post users_messages_path, params: { message_form: { user_id: user.id,
                                                              room_id: room.id,
                                                              body: '' } }
        end .not_to change(Message, :count)
        expect(response).to have_http_status '200'
      end
    end
    context '他人のメッセージルームに送信しようとした場合' do
      let(:another_room) { create(:room) }
      it 'メッセージは保存されず、rootにリダイレクトする' do
        login_user(user)
        expect do
          post users_messages_path, params: { message_form: { user_id: user.id,
                                                              room_id: another_room.id,
                                                              body: 'another_room' } }
        end .not_to change(Message, :count)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to root_path
      end
    end
    context 'メッセージが有効だった場合' do
      it 'メッセージは保存され、メッセージ画面にリダイレクトする' do
        login_user(user)
        expect { post users_messages_path, params: { message_form: { user_id: user.id, room_id: room.id, body: 'MyText' } } }.to change(Message, :count).by(1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_room_path(room)
      end
    end
  end

  describe 'destroyアクション' do
    context '自分のメッセージを削除する場合' do
      it 'メッセージを削除し、再度メッセージ画面を表示する' do
        login_user(user)
        message = Message.create(user_id: user.id, room_id: room.id, body: 'MyText')
        expect { delete users_message_path(message) }.to change(Message, :count).by(-1)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_room_path(room)
      end
    end

    context '他のユーザーのメッセージを削除しようとした場合' do
      it 'メッセージは削除できない' do
        login_user(user)
        message = Message.create(user_id: another_user.id, room_id: room.id, body: 'MyText')
        expect { delete users_message_path(message) }.not_to change(Message, :count)
        expect(response).to have_http_status '302'
        expect(response).to redirect_to users_basic_path(user)
      end
    end
  end
end
