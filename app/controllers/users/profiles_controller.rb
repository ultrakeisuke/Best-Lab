# frozen_string_literal: true

class Users::BasicsController < ApplicationController

  def home
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
end
