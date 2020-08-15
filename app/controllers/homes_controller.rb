class HomesController < ApplicationController
  before_action :authenticate_user!, only: :index
  
  def index
  end

  def help
  end

  def about
  end

  def contact
  end

end
