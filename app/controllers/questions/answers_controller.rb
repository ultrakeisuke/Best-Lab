# frozen_string_literal: true

class Questions::AnswersController < ApplicationController
  before_action :authenticate_user!

  # 回答の新規作成
  def create
    @answer = AnswerForm.new
    @answer.assign_attributes(answer_params)
    respond_to do |format|
      if @answer.save
        @reply = ReplyForm.new
        @post = Post.find(@answer.post_id)
        @answers = @post.answers
        @post.solved_by_questioner if @post.user_id == @answer.user_id # 自己解決した場合の処理
        answer = Answer.where(user_id: @answer.user_id).last
        answer.send_notice_to_questioner_or_answerers # 質問に回答した際の通知処理
        format.html { redirect_to questions_post_path(@answer.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :errors }
      end
    end
  end

  # 回答の編集
  def update
    answer = Answer.find(answer_params[:id])
    @answer = AnswerForm.new(answer)
    @answer.assign_attributes(answer_params.except(:id))
    respond_to do |format|
      if @answer.save
        @post = Post.find(answer.post_id)
        @answers = @post.answers
        format.html { redirect_to questions_post_path(answer.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :errors }
      end
    end
  end

  private
  
    def answer_params
      params.require(:answer_form).permit(:id, :body, :post_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

  
end
