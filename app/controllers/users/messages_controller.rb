# frozen_string_literal: true

class Users::MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    @message = MessageForm.new
    @message.assign_attributes(message_form_params)
    if @message.save
      redirect_to users_room_path(@message.room_id)
    else
      @room = Room.find(@message.room_id)
      @another_entry = @room.entries.find_by('user_id != ?', current_user.id)
      render "users/rooms/show"
    end
  end

  def destroy
    message = Message.find(params[:id])
    # 自分のメッセージ以外は削除できないようにする
    if message.user_id == current_user.id
      message.destroy
      redirect_to users_room_path(message.room_id)
    else
      redirect_to users_room_path(message.room_id)
    end
  end

  private

    def message_form_params
      params.require(:message_form).permit(:room_id, :body, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

end
