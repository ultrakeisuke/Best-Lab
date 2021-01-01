# frozen_string_literal: true

class Questions::RepliesController < ApplicationController
  before_action :authenticate_user!

  # リプライの新規作成
  def create
    @reply = ReplyForm.new
    @reply.assign_attributes(reply_params)
    respond_to do |format|
      if @reply.save
        @answer = Answer.find(@reply.answer_id)
        @answers = Answer.where(post_id: @reply.post_id)
        @post = Post.find(@reply.post_id)
        format.html { redirect_to questions_post_path(@reply.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :errors }
      end
    end
  end

  # リプライの編集
  def update
    # パラメータ中のidをもとに編集するリプライを選出する
    @target_reply = Reply.find(reply_params[:id])
    @reply = ReplyForm.new(@target_reply)
    # パラメータからidを削除してリプライを更新する
    params = reply_params
    params.delete(:id)
    @reply.assign_attributes(params)
    respond_to do |format|
      if @reply.save
        @answer = Answer.find(@reply.answer_id)
        @post = Post.find(@reply.post_id)
        format.html { redirect_to questions_post_path(@reply.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :update_errors }
      end
    end
  end

  private

    def reply_params
      params.require(:reply_form).permit(:id, :body, :post_id, :answer_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

end
