# frozen_string_literal: true

class Users::MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
      redirect_to users_room_path(message.room)
    elsif message.body.blank? && message.pictures.blank?
      redirect_to users_room_path(message.room)
      flash[:alert] = 'メッセージを送信するには文字か画像を入力してください。'
    else
      redirect_to users_room_path(message.room)
      flash[:alert] = '送信できる文字数の上限は10000文字です。'
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to users_room_path(message.room_id)
  end

  private

    def message_params
      params.require(:message).permit(:user_id, :room_id, :body, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

end