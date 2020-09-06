# frozen_string_literal: true

class Users::RoomsController < ApplicationController
  before_action :authenticate_user!, only: [:index, :show, :create]

  def create
    # メッセージルームを作成
    room = Room.create
    # Entryモデルにログインユーザーのレコードを作成
    current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    # Entryモデルに相手のレコードを作成
    another_entry = Entry.create(user_id: params[:entry][:user_id], room_id: room.id)
    # 作成した部屋を表示
    redirect_to room_path(room)
  end

  def index
    # ログインユーザーのすべてのentryを取得
    current_entries = current_user.entries
    my_room_ids = []
    # ログインユーザーのentryをもとに、room_idをひとつずつmy_room_idsに格納
    current_entries.each do |entry|
      my_room_ids << entry.room.id
    end
    # ログインユーザーが参加しているすべてのroomから、user_idがログインユーザーでないレコードを取得
    @another_entries = Entry.where(room_id: my_room_ids).where.not(user_id: current_user.id)
  end

  def show
    # メッセージ相手のroom情報をパスから取得し、@roomに代入
    @room = Room.find(params[:id])
    # メッセージを作成
    @message = Message.new
    # ひとつのroomが所属するentryは2つ(user_idがログインユーザー、相手)なので、
    # ログインユーザーでないほうのuser_idから取得できるentryはメッセージ相手のものとなる
    @another_entry = @room.entries.find_by('user_id != ?', current_user.id)
  end

end