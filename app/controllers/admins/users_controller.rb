# frozen_string_literal: true

class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_user, only: [:show, :destroy]

  PER = 10

  def index
    @users = User.ransack(params[:q]).result.page(params[:page]).per(PER)
  end

  def show
    @user = User.find(params[:id])
    @posts = Post.where(user_id: @user).page(params[:page]).per(PER)
  end

  def destroy
    user = User.find(params[:id])
    user.inactivate_account
    redirect_to admins_user_path(user)
  end

  private

    # DBに存在しないユーザーidを入力するとrootにリダイレクト
    def check_user
      redirect_to root_path unless User.exists?(id: params[:id])
    end
  
end
