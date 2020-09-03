# frozen_string_literal: true

class Users::BasicsController < ApplicationController
  before_action :authenticate_user!, only: :index
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
    # 参加するメッセージルーム情報を取得
    @current_user_entry = Entry.where(user_id: current_user.id)
    # 相手のメッセージルーム情報を取得
    @another_user_entry = Entry.where(user_id: @user.id)

    unless @current_user_entry.id == @another_user_entry.id
      @current_user_entry.each do |current|
        @another_user_entry.each do |another|
          # ルームが存在する場合
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      # メッセージルームが存在しない場合は新規作成
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end
  
end
