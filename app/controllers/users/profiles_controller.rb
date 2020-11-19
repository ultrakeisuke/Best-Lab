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
    else
      render :new
    end
  end

  # プロフィール編集画面
  def edit
    @profile = ProfileForm.new(current_user)
  end

  # プロフィール編集
  def update
    @profile = ProfileForm.new(current_user)
    # 複数のattributeをまとめて更新
    @profile.assign_attributes(params)
    if @profile.save
      redirect_to users_basic_path(current_user.id)
    else
      render :edit
    end
  end

  private

    # createアクション用ストロングパラメータ
    def profile_form_params
      params.require(:profile_form).permit(:affiliation, :school, :faculty, :department, :laboratory, :content).merge(user_id: current_user.id)
    end

end
