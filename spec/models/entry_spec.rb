require 'rails_helper'

RSpec.describe Entry, type: :model do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  describe "self.another_entriesメソッド" do
    context "ログインユーザーがエントリーを持っていない場合" do
      it "空の配列を返す" do
        another_entries = Entry.another_entries(user)
        expect(another_entries).to eq []
      end
    end
    context "ログインユーザーがエントリーを持っている場合" do
      before do
        @users = create_list(:test_users, 2)
        @rooms = create_list(:rooms, 3)
        # ログインユーザーと部屋を共有するエントリーを定義
        @entry1 = create(:entry, room_id: @rooms[0].id, user_id: user.id)
        @entry2 = create(:entry, room_id: @rooms[0].id, user_id: @users[0].id)
        @entry3 = create(:entry, room_id: @rooms[1].id, user_id: user.id)
        @entry4 = create(:entry, room_id: @rooms[1].id, user_id: @users[1].id)
        # ログインユーザーと部屋を共有していないエントリーを定義
        @entry5 = create(:entry, room_id: @rooms[2].id, user_id: @users[0].id)
        @entry6 = create(:entry, room_id: @rooms[2].id, user_id: @users[1].id)
      end
      it "ログインユーザーと部屋を共有している他人のエントリーを返す" do
        another_entries = Entry.another_entries(user)
        expect(another_entries).to eq [@entry2, @entry4]
      end
    end
  end

  describe "self.partner_of(user)メソッド" do
    before do
      @room = create(:room)
      @user_entry = create(:entry, room_id: @room.id, user_id: user.id)
      @another_entry = create(:entry, room_id: @room.id, user_id: another_user.id)
    end
    it "相手のエントリーを返す" do
      another_entry = @room.entries.partner_of(user)
      expect(another_entry).to eq @another_entry
    end
  end

  describe "self.sorted_entries(user)メソッド" do
    before do
      @users = create_list(:test_users, 3)
      @rooms = create_list(:rooms, 3)
      @entry1 = create(:entry, room_id: @rooms[0].id, user_id: user.id)
      @entry2 = create(:entry, room_id: @rooms[0].id, user_id: @users[0].id)
      @entry3 = create(:entry, room_id: @rooms[1].id, user_id: user.id)
      @entry4 = create(:entry, room_id: @rooms[1].id, user_id: @users[1].id)
      @entry5 = create(:entry, room_id: @rooms[2].id, user_id: user.id)
      @entry6 = create(:entry, room_id: @rooms[2].id, user_id: @users[2].id)
    end
    context "すべてのエントリーにメッセージがない場合" do
      it "空の配列を返す" do
        another_entries = Entry.another_entries(user)
        sorted_entries = another_entries.sorted_entries(user)
        expect(sorted_entries).to eq []
      end
    end
    context "メッセージを持つエントリーがある場合" do
      before do
        # @rooms[2]はメッセージを持たない部屋とする
        message1 = create(:message, room_id: @rooms[0].id, user_id: user.id, created_at: Time.current)
        message2 = create(:message, room_id: @rooms[1].id, user_id: user.id, created_at: Time.current + 1.second)
      end
      it "メッセージがないエントリーを取り除きソートして返す" do
        another_entries = Entry.another_entries(user)
        expect(another_entries).to eq [@entry2, @entry4, @entry6]
        # メッセージがない@entry6を取り除き、投稿時刻をもとにソート
        sorted_entries = another_entries.sorted_entries(user)
        expect(sorted_entries).to eq [@entry4, @entry2]
      end
    end
  end

  describe "self.find_or_create_partnerメソッド" do
    let(:room) { create(:room) }
    context "共通の部屋を持つ場合" do
      it "@is_roomはture, @room_idは部屋番号を返す" do
        current_entry = create(:entry, user_id: user.id, room_id: room.id)
        another_entry = create(:entry, user_id: another_user.id, room_id: room.id)
        # arrayは@is_room, @room_id, @entryの配列
        array = Entry.find_or_create_partner(user, another_user)
        expect(array[0]).to eq true
        expect(array[1]).to eq current_entry.room_id
        expect(array[2]).not_to be_present
      end
    end
    context "共通の部屋を持たない場合" do
      it "@entryを生成して返す" do
        array = Entry.find_or_create_partner(user, another_user)
        expect(array[0]).to eq nil
        expect(array[1]).to eq nil
        expect(array[2]).to be_present
      end
    end
  end

end
