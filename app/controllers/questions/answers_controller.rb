# frozen_string_literal: true

class Questions::AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :restricted_editing_answer, only: :update

  # 回答、リプライした質問を一覧表示
  def index
    @comment_lists = QuestionNotice.sorted_comment_entries(current_user)
    @comment_lists = @comment_lists.page(params[:page])
  end

  # 回答の新規作成
  def create
    @answer = AnswerForm.new
    @answer.assign_attributes(answer_params)
    @post = Post.find(answer_params[:post_id])
    redirect_to root_path if @post.nil? # @postが見つからない場合の処理
    respond_to do |format|
      if @answer.save
        @reply = ReplyForm.new
        @answers = @post.answers
        @post.solved_by_questioner if @post.user_id == @answer.user_id # 自己解決した場合の処理
        answer = Answer.where(user_id: @answer.user_id).last
        answer&.send_notice_to_questioner_or_answerers # 質問に回答した際の通知処理
        format.html { redirect_to questions_post_path(@answer.post_id) }
        format.js
      else
        format.html { render 'questions/posts/show' }
        format.js { render :errors }
      end
    end
  end

  # 回答の編集
  def update
    answer = Answer.find(answer_params[:id])
    @post = Post.find(answer.post_id)
    redirect_to root_path if @post.nil? # @postが見つからない場合の処理
    @answer = AnswerForm.new(answer)
    @answer.assign_attributes(answer_params.except(:id))
    respond_to do |format|
      if @answer.save
        @answers = @post.answers
        format.html { redirect_to questions_post_path(answer.post_id) }
        format.js
      else
        format.html { render 'questions/posts/show' }
        format.js { render :errors }
      end
    end
  end

  private

  def answer_params
    params.require(:answer_form).permit(:id, :body, :post_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
  end

  # 他人の回答は編集できないよう制限する
  def restricted_editing_answer
    redirect_to users_basic_path(current_user) if current_user.answers.ids.exclude?(params[:id].to_i)
  end
end
