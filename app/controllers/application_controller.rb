class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :profile_search
  before_action :user_search
  before_action :post_search

  # ユーザーの検索フォームをサイドバーに常に表示する処理
  def profile_search
    @profile_search = Profile.ransack(params[:q])
  end

  # 管理者用にユーザーの検索フォームをサイドバーに表示する処理
  def user_search
    @user_search = User.ransack(params[:q])
  end

  # 質問の検索フォームをサイドバーに常に表示する処理
  def post_search
    @post_search = Post.ransack(params[:q])
    # カテゴリーのセレクトボックスに初期値をセット
    @parent_categories_for_search = Category.where(ancestry: nil)
    @children_categories_for_search = @parent_categories_for_search.first.children
  end

  protected

end


