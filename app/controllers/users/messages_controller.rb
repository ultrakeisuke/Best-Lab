# frozen_string_literal: true

class Users::MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
      redirect_to users_room_path(message.room)
    elsif message.pictures.length > 4
      flash[:alert] = '投稿できる画像は4枚までです。'
      redirect_to users_room_path(message.room)
    elsif message.body.length > 10000
      flash[:alert] = '送信できる文字は10000文字までです。'
      redirect_to users_room_path(message.room)
    else
      flash[:alert] = 'メッセージを送信するには文字か画像を入力してください。'
      redirect_to users_room_path(message.room)
    end
  end

  def destroy
    message = Message.find(params[:id])
    # 自分のメッセージ以外は削除できないようにする
    if message.user_id == current_user.id
      message.destroy
      redirect_to users_room_path(message.room_id)
    end
  end

  private

    def message_params
      params.require(:message).permit(:user_id, :room_id, :body, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

end