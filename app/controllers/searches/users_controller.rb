# frozen_string_literal: true

class Searches::UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザーの検索一覧を表示
  def index
    if params[:q][:description_cont_any].present?
      params[:q][:description_cont_any] = params[:q][:description_cont_any].split(/[[:blank:]]+/)
    end
    # 所属が未選択の場合は全検索とする
    params[:q][:affiliation_eq].clear if params[:q][:affiliation_eq] == 'unselected'
    @profiles = Profile.ransack(params[:q]).result.page(params[:page])
  end
end
