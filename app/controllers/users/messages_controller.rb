# frozen_string_literal: true

class Users::MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    # FormObjectを使用するためMessageFormクラスでメッセージを作成
    @message_form = MessageForm.new(message_params)
    if @message.save
      redirect_to users_room_path(@message_form.room_id)
    else
      redirect_to users_room_path(@message_form.room_id)
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
      params.require(:message_form).permit(:user_id, :room_id, :body, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

end