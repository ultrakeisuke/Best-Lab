# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController

  def new
    super
  end

  def show
    super
  end

  def create
    super
  end

    # def confirm_params
    #   params.require(resource_name).permit(:password, :password_confirmation)
    # end


  protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource)
  end
end
