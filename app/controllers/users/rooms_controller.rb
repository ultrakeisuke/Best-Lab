# frozen_string_literal: true

class Users::RoomsController < ApplicationController
  before_action :authenticate_user!, only: %i[index show create]
  before_action :restricted_room_viewing, only: [:show]

  def create
    # メッセージルームを作成
    room = Room.create
    # Entryモデルにログインユーザーのレコードを作成
    @current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    # Entryモデルに相手のレコードを作成
    @another_entry = Entry.create(user_id: entry_params[:user_id], room_id: room.id)
    # 作成した部屋を表示
    redirect_to users_room_path(room)
  end

  def index
    # メッセージ相手と部屋の情報を取得
    @another_entries = Entry.another_entries(current_user)
    # 最後にやりとりしたメッセージが新しい順にソート
    @sorted_entries = @another_entries.sorted_entries(current_user)
  end

  def show
    @room = Room.find(params[:id])
    @room&.remove_notice(current_user) # メッセージルームに入ると通知が外れる処理
    @message = MessageForm.new # formのmodelに入れるオブジェクトを作成
    @another_entry = @room.entries.partner_of(current_user) # メッセージ相手と部屋の情報を取得
    redirect_to root_path if @another_entry.nil? # 相手の情報がなかった場合の処理
  end

  private

  def entry_params
    params.require(:entry).permit(:user_id)
  end

  # 他人のメッセージルームを閲覧できないよう制限
  def restricted_room_viewing
    current_room_ids = current_user.entries.map(&:room_id)
    redirect_to users_basic_path(current_user) if current_room_ids.exclude?(params[:id].to_i)
  end
end
