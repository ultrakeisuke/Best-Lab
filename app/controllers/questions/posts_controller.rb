# frozen_string_literal: true

class Questions::PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :edit, :update]
  before_action :set_categories_for_new, only: [:new, :create]
  before_action :set_categories_for_edit, only: [:edit, :update]
  before_action :set_replies, only: [:show]
  
  # すべての質問一覧
  def index
    @posts = Post.all.order(id: "DESC")
  end

  # 各質問の表示画面
  def show
    @post = Post.find(params[:id])
  end

  # 投稿の新規作成画面
  def new
    @post = PostForm.new
  end

  def create
    @post = PostForm.new
    @post.assign_attributes(post_params)
    if @post.save
      redirect_to users_basic_path(current_user), flash: { notice: "質問を投稿しました。" }
    else
      render :new
    end
  end

  # 投稿の編集画面
  def edit
    post = Post.find(params[:id])
    @post = PostForm.new(post)
    # すでに作成した投稿のカテゴリーを取得しセレクトボックスに表示する
    @selected_parent_category = post.category.parent
  end

  def update
    @post = PostForm.new(post = Post.find(params[:id]))
    @post.assign_attributes(post_params)
    if @post.save
      redirect_to users_basic_path(current_user), flash: { notice: "質問を編集しました。" }
    else
      render :edit
    end
  end

  # 親カテゴリーを選択した際に子カテゴリーを動的に変化するメソッド
  def get_children_categories
    @children_categories = Category.find_by(id: "#{params[:parent_category_id]}", ancestry: nil).children
  end

  private

    def post_params
      params.require(:post_form).permit(:category_id, :title, :content, :status, pictures_attributes: [:picture]).merge(user_id: current_user.id)
    end

    # 新規作成画面のセレクトボックスの初期値を表示
    def set_categories_for_new
      @parent_categories = Category.where(ancestry: nil)
      @children_categories = @parent_categories.first.children
    end

    # 編集画面のセレクトボックスの初期値を表示
    def set_categories_for_edit
      @parent_categories = Category.where(ancestry: nil)
      @children_categories = Post.find(params[:id]).category.parent.children
    end

    # 質問に対するリプライを表示
    def set_replies
      @parent_replies = Reply.where(post_id: params[:id], ancestry: nil)
      @parent_replies.each do |parent|
        @children_replies = Reply.where(post_id: params[:id], ancestry: parent.id)
      end
    end

end
