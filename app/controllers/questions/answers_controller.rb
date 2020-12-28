# frozen_string_literal: true

class Questions::AnswersController < ApplicationController
  before_action :authenticate_user!

  # 回答の新規作成
  def create
    @answer = AnswerForm.new
    @answer.assign_attributes(answer_params)
    respond_to do |format|
      if @answer.save
        format.html { redirect_to questions_post_path(@answer.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :errors }
      end
    end
  end

  private
  
    def answer_params
      params.require(:answer_form).permit(:body, :post_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

  
end
