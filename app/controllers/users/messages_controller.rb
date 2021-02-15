# frozen_string_literal: true

class Users::MessagesController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :restricted_destroying_message, only: :destroy

  def create
    @message = MessageForm.new
    @message.assign_attributes(message_form_params)
    if @message.save
      message = Message.where(user_id: current_user).last
      message&.send_notice_to_partner # メッセージ相手に通知を送信する処理
      redirect_to users_room_path(@message.room_id)
    else
      @room = Room.find(@message.room_id)
      @another_entry = @room.entries.partner_of(current_user)
      redirect_to root_path if @room.nil? || @another_entry.nil? # roomとentryが見つからなかった場合の処理
      render "users/rooms/show"
    end
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
    redirect_to users_room_path(message.room_id)
  end

  private

    def message_form_params
      params.require(:message_form).permit(:room_id, :body, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

    # 他人のメッセージは削除できない制限
    def restricted_destroying_message
      redirect_to users_basic_path(current_user) if current_user.messages.ids.exclude?(params[:id].to_i)
    end

end
