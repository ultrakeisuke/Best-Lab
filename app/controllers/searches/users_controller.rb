# frozen_string_literal: true

class Searches::UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザーの検索一覧を表示
  def index
    @q = Profile.ransack(search_user_params)
    @profiles = @q.result.page(params[:page])
    flash.now[:notice] = "お探しのユーザーは見つかりませんでした。" if @profiles.blank?
  end

  def search_user_params
    params.require(:q).permit(:affiliation_eq, :school_eq, :faculty_eq, :department_eq, :laboratory_eq, :content_cont)
  end

end
