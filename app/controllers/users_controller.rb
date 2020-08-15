# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    redirect_to root_url
  end

  private
    def admin_user
      redirect_to root_path unless current_user.admin?
    end
  
end
