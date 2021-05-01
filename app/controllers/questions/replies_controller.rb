# frozen_string_literal: true

class Questions::RepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :restricted_editing_reply, only: :update

  # リプライの新規作成
  def create
    @reply = ReplyForm.new
    @reply.assign_attributes(reply_params)
    @answer = Answer.find(reply_params[:answer_id])
    redirect_to root_path if @answer.nil? # @answerが見つからない場合の処理
    @post = @answer.post
    respond_to do |format|
      if @reply.save
        @answers = @post.answers
        reply = Reply.where(user_id: @reply.user_id).last
        reply&.send_notice_to_commenter # 回答にリプライした際の通知処理
        format.html { redirect_to questions_post_path(reply.answer.post_id) }
        format.js
      else
        format.html { render 'questions/posts/show' }
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
    @answer = Answer.find(@target_reply.answer_id)
    redirect_to root_path if @answer.nil? # @answerが見つからない場合の処理
    @post = @answer.post
    respond_to do |format|
      if @reply.save
        format.html { redirect_to questions_post_path(@target_reply.answer.post_id) }
        format.js
      else
        format.html { render 'questions/posts/show' }
        format.js { render :update_errors }
      end
    end
  end

  private

  def reply_params
    params.require(:reply_form).permit(:id, :body, :answer_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
  end

  # 他人のリプライは編集できないよう制限する
  def restricted_editing_reply
    redirect_to users_basic_path(current_user) if current_user.replies.ids.exclude?(params[:id].to_i)
  end
end
