# frozen_string_literal: true

class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_user, only: [:show, :destroy]

  PER = 10

  def index
    params[:q][:name_cont_any] = params[:q][:name_cont_any].split(/[[:blank:]]+/) if params[:q][:name_cont_any].present?
    @users = User.ransack(params[:q]).result.page(params[:page]).per(PER)
  end

  def show
    @user = User.find(params[:id])
  end

  # 特定のユーザーの情報を削除する
  def destroy
    user = User.find(params[:id])
    user.inactivate_account
    user.inactivate_comments_and_notices
    redirect_to admins_user_path(user)
  end

  private

    # DBに存在しないユーザーidを入力するとrootにリダイレクト
    def check_user
      redirect_to root_path unless User.exists?(id: params[:id])
    end
  
end
