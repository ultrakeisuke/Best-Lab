# frozen_string_literal: true

class Users::MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
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
      params.require(:message).permit(:user_id, :room_id, :body, pictures_attributes: [:picture])
    end

end