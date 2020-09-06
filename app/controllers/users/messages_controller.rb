# frozen_string_literal: true

class Users::MessagesController < ApplicationController

  def create
    message = Message.new(message_params)
    message.user_id = current_user_id
    if massage.save
      redirect_to users_room_path(message.room)
    else
      redirect_to users_basics_path
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to users_basics_path
  end

  private

    def message_params
      params.require(:message).permit(:room_id, :body)
    end

end