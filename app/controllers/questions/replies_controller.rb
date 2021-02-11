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
        @post = @answer.post
        @answers = @post.answers
        reply = Reply.where(user_id: @reply.user_id).last
        reply.send_notice_to_commenter # 回答にリプライした際の通知処理
        format.html { redirect_to questions_post_path(@reply.post_id) }
        format.js
      else
        format.html { render "questions/posts/show" }
        format.js { render :create_errors }
      end
    end
  end

  # リプライの編集
  def update
    # パラメータ中のidをもとに編集するリプライを選出する
    @target_reply = Reply.find(reply_params[:id])
    @reply = ReplyForm.new(@target_reply)
    # パラメータからidを削除してリプライを更新する
    @reply.assign_attributes(reply_params.except(:id))
    respond_to do |format|
      if @reply.save
        @answer = Answer.find(@reply.answer_id)
        @post = @answer.post
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
