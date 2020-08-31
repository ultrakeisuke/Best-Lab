# frozen_string_literal: true

class Users::BasicsController < ApplicationController

  def show
    @user = User.find(params[:id])
  end
  
end
