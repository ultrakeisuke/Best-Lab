# frozen_string_literal: true

class Users::BasicsController < ApplicationController
  before_action :authenticate_user!, only: :show
  before_action :restricted_viewing_deleted_user, only: :show
  
  def show
    @user = User.find(params[:id])
    # 共通のメッセージルームを持つ場合はroom_idを返す
    @room_id = Entry.find_room_id(current_user, @user) if current_user != @user
    # room_idがない場合はルーム作成フォーム用のインスタンスを生成
    @entry = Entry.new if @room_id.nil?
    # ユーザーが投稿した質問を降順で表示
    @posts = Post.where(user_id: @user).order(created_at: :desc)
  end
  
end

  private

    # 退会済みのユーザーの画面は表示できないように制限
    def restricted_viewing_deleted_user
      redirect_to root_path if User.find(params[:id]).discarded?
    end
