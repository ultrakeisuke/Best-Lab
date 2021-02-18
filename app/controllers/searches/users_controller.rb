# frozen_string_literal: true

class Searches::UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザーの検索一覧を表示
  def index
    params[:q][:description_cont_any] = params[:q][:description_cont_any].split(/[[:blank:]]+/) if params[:q][:description_cont_any].present?
    @profiles = Profile.ransack(params[:q]).result.page(params[:page])
  end

end
