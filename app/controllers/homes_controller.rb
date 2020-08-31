class HomesController < ApplicationController
  before_action :authenticate_user!, only: :top
  
  def top
  end

  def help
  end

  def contact
  end

end
