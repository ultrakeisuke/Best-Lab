# frozen_string_literal: true

class Users::BasicsController < ApplicationController
  before_action :authenticate_user!, only: :home
  
  def home
    @users = User.all
  end
  
  def show
    @user = User.find(params[:id])
  end
  
end
