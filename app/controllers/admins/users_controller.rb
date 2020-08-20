# frozen_string_literal: true

class Admins::UsersController < ApplicationController

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
end