class ApplicationController < ActionController::Base

  protect_from_forgery with: :exception

  before_action :profile_search

  # 検索フォームをサイドバーに常に表示するためsearch_form_forの@qを定義
  def profile_search
    @q = Profile.ransack(params[:q])
  end

  protected

end


