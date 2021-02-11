# frozen_string_literal: true

class Users::BasicsController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :restricted_viewing_deleted_user, only: :show
  
  def show
    @user = User.find(params[:id])
    # ダイレクトメッセージ用の部屋を相手と共有しているか確認する処理
    @is_room, @room_id, @entry = Entry.find_or_create_partner(current_user, @user) if current_user != @user
    # ユーザーが投稿した質問を降順で表示
    @posts = Post.where(user_id: @user).order(created_at: :desc)
  end
  
end

  private

    # 退会済みのユーザーの画面は表示できないように制限
    def restricted_viewing_deleted_user
      redirect_to root_path if User.find(params[:id]).discarded?
    end
