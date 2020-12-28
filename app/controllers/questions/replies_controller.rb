# frozen_string_literal: true

class Questions::RepliesController < ApplicationController
  before_action :authenticate_user!

  # リプライの新規作成
  def create
    @reply = ReplyForm.new
    @reply.assign_attributes(reply_params)
    respond_to do |format|
      if @reply.save
        format.html { redirect_to questions_post_path(@reply.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :errors }
      end
    end
  end

  private

    def reply_params
      params.require(:reply_form).permit(:body, :post_id, :answer_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

end
