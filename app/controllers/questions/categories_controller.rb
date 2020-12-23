# frozen_string_literal: true

class Questions::CategoriesController < ApplicationController
  
  # 1つのカテゴリーに所属する質問を一覧表示する
  def show
    @category = Category.find(params[:id])
    @posts = Post.order(created_at: :desc).where(category_id: @category).page(params[:page])
  end

end
