# frozen_string_literal: true

class Searches::QuestionsController < ApplicationController
  # 質問の検索一覧を表示
  def index
    if params[:q][:content_cont_any].present?
      params[:q][:content_cont_any] = params[:q][:content_cont_any].split(/[[:blank:]]+/)
    end
    @posts = Post.order(created_at: :desc).ransack(params[:q]).result.page(params[:page])
  end

  # 質問の検索フォームで親カテゴリーを選択した際に子カテゴリーを動的に変化させる処理
  def get_children_categories_for_search
    @children_categories_for_search = Category.find_by(id: params[:parent_category_id].to_s, ancestry: nil).children
  end
end
