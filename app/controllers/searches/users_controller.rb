# frozen_string_literal: true

class Searches::UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザーの検索一覧を表示
  def index
    params[:q].each do |key, value|
      params[:q].delete(key) if value.blank?
    end

    if params[:q].present?
      @q = Profile.ransack(search_user_params)
      @profiles = @q.result.page(params[:page])
      flash.now[:notice] = "お探しのユーザーは見つかりませんでした。" if @profiles.blank?
    else
      flash.now[:notice] = "最低でも1つの項目を入力してください。"
    end
  end

  private

    def search_user_params
      params.require(:q).permit(:affiliation_eq, :school_eq, :faculty_eq, :department_eq, :laboratory_eq, :content_cont)
    end

end
