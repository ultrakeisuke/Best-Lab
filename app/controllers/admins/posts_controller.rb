# frozen_string_literal: true

class Admins::PostsController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_post
 
  # 投稿の詳細画面
  def show
    @post = Post.find(params[:id])
  end

  # 不適切な投稿の削除
  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to admins_user_path(post.user)
  end

  private

    # DBに存在しない投稿idを入力するとrootにリダイレクト
    def check_post
      redirect_to root_path unless Post.exists?(id: params[:id])
    end
  
end
