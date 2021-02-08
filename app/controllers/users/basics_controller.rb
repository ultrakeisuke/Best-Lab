# frozen_string_literal: true

class Users::BasicsController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :restricted_viewing_deleted_user, only: :show
  
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

    # ユーザーが投稿した質問を降順で表示
    @posts = Post.where(user_id: @user).order(created_at: :desc)
  end
  
end

  private

    # 退会済みのユーザーの画面は表示できないように制限
    def restricted_viewing_deleted_user
      redirect_to root_path if User.find(params[:id]).discarded?
    end
