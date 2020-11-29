# frozen_string_literal: true

class Users::BasicsController < ApplicationController
  before_action :authenticate_user!, only: :show
  
  def show
    @user = User.find(params[:id])
    # ログインユーザーのすべてのentryを取得
    @current_entry = Entry.where(user_id: current_user.id)
    # メッセージ相手のすべてのentryを取得
    @another_entry = Entry.where(user_id: @user.id)
    # ログインユーザー以外のユーザーのプロフィール画面を表示した場合
    unless current_user.id == @user.id
      # ログインユーザーとメッセージ相手に共通のroomが存在するかどうかを
      # entryから探し出し、存在の有無を@is_roomというインスタンスで識別する
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      # 共通のroomが存在しなかった場合、roomとentryのインスタンスを作成
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end
  
end
