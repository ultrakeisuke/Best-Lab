# frozen_string_literal: true

class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!

  # プロフィール新規作成画面
  def new
    @profile = ProfileForm.new
  end

  # プロフィール作成
  def create
    @profile = ProfileForm.new(profile_form_params)
    if @profile.save
      redirect_to users_basic_path(current_user.id)
    end
  end

  # プロフィール編集画面
  def edit
    @profile = Profile.find(params[:id])
  end

  # プロフィール編集
  def update
    @profile = Profile.find(params[:id])
    @profile.update(profile_params)
    redirect_to users_basic_path(current_user.id)
  end

  private

    # createアクション用ストロングパラメータ
    def profile_form_params
      params.require(:profile_form).permit(:affiliation, :school, :faculty, :department, :laboratory, :content).merge(user_id: current_user.id)
    end

    # updateアクション用ストロングパラメータ
    def profile_params
      params.require(:profile).permit(:affiliation, :school, :faculty, :department, :laboratory, :content)
    end

end
