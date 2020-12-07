# frozen_string_literal: true

class Searches::UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザーの検索一覧を表示
  def index
    params[:q][:content_cont_any] = params[:q][:content_cont_any].split(/[[:blank:]]+/)
    @profiles = Profile.ransack(params[:q]).result
  end

end
