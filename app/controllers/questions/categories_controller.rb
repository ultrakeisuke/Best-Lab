# frozen_string_literal: true

class Questions::CategoriesController < ApplicationController
  before_action :check_category_id
  
  # 1つのカテゴリーに所属する質問を一覧表示する
  def show
    @category = Category.find(params[:id])
    @posts = Post.order(created_at: :desc).where(category_id: @category).page(params[:page])
  end

  private

    # DBに存在しないカテゴリーidを入力した場合はrootにリダイレクトする
    def check_category_id
      redirect_to root_path unless Category.exists?(id: params[:id])
    end

end
