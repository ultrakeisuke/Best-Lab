# frozen_string_literal: true

class Questions::PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[create edit update select_best_answer]
  before_action :restricted_editing_post, only: %i[edit update select_best_answer]
  before_action :set_categories_for_new, only: %i[new create]
  before_action :set_categories_for_edit, only: %i[edit update]

  # 各質問の表示画面
  def show
    @post = Post.find(params[:id])
    @post.remove_notice(current_user) # 投稿詳細画面に入ると通知が外れる処理
    # 回答とそのリプライフォーム用のオブジェクトを定義
    @answer = AnswerForm.new
    @reply = ReplyForm.new
    # ある質問に対するログインユーザーの回答を定義
    @your_answer = Answer.where(post_id: params[:id], user_id: current_user)
    # ある質問に対する回答を定義
    @answers = Answer.where(post_id: params[:id])
  end

  # 投稿の新規作成画面
  def new
    @post_form = PostForm.new
  end

  def create
    @post_form = PostForm.new
    @post_form.assign_attributes(post_params)
    if @post_form.save
      post = Post.where(user_id: current_user).last
      post&.create_notice # 質問投稿者用の通知レコードを作成
      redirect_to users_basic_path(current_user), flash: { notice: '質問を投稿しました。' }
    else
      render :new
    end
  end

  # 投稿の編集画面
  def edit
    @post = Post.find(params[:id])
    @post_form = PostForm.new(@post)
    # すでに作成した投稿のカテゴリーを取得しセレクトボックスに表示する
    @selected_parent_category = @post.category.parent
  end

  def update
    @post = Post.find(params[:id])
    @post_form = PostForm.new(@post)
    @post_form.assign_attributes(post_params)
    if @post_form.save
      redirect_to questions_post_path(@post), flash: { notice: '質問を編集しました。' }
    else
      render :edit
    end
  end

  # 親カテゴリーを選択した際に子カテゴリーを動的に変化させる処理
  def get_children_categories
    @children_categories = Category.find_by(id: params[:parent_category_id].to_s, ancestry: nil).children
  end

  # ベストアンサーを選出する処理
  def select_best_answer
    post = Post.find(params[:id])
    @post_form = PostForm.new(post)
    @post_form.assign_attributes(post_params)
    if @post_form.save
      post.send_notice_to_answerers # 回答者全員に通知を送信する
      redirect_to questions_post_path(post), flash: { notice: 'ベストアンサーが決定しました！' }
    else
      render 'questions/posts/show'
    end
  end

  private

  def post_params
    params.require(:post_form).permit(:category_id, :title, :content, :status, :best_answer_id, pictures_attributes: [:picture]).merge(user_id: current_user.id)
  end

  # 新規作成画面のセレクトボックスの初期値を表示
  def set_categories_for_new
    @parent_categories = Category.where(ancestry: nil)
    @children_categories = @parent_categories.first&.children
  end

  # 編集画面のセレクトボックスの初期値を表示
  def set_categories_for_edit
    @parent_categories = Category.where(ancestry: nil)
    @children_categories = Post.find(params[:id]).category.parent.children
  end

  # 他人の質問編集画面を閲覧できない、かつ編集できない制限
  def restricted_editing_post
    redirect_to users_basic_path(current_user) if current_user.posts.ids.exclude?(params[:id].to_i)
  end
end
