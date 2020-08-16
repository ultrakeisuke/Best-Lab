# frozen_string_literal: true

class AdminController < ApplicationController

  def index
    @users = User.all.page(params[:page])
  end

  def show
    @user = User.find(params[:id])
  end
  
end