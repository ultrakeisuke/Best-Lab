# frozen_string_literal: true

class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :restricted_profile_editing, only: [:edit, :update]

  # プロフィール新規作成画面
  def new
    @profile = ProfileForm.new
  end

  # プロフィール作成
  def create
    @profile = ProfileForm.new
    @profile.assign_attributes(profile_form_params)
    if @profile.save
      redirect_to users_basic_path(current_user), flash: { notice: "プロフィールを保存しました。" }
    else
      render :new
    end
  end

  # プロフィール編集画面
  def edit
    # ログインユーザーのプロフィール情報を取得
    @profile = ProfileForm.new(Profile.find(params[:id]))
  end

  # プロフィール編集
  def update
    @profile = ProfileForm.new(Profile.find(params[:id]))
    # 複数のattributeをまとめて更新
    @profile.assign_attributes(profile_form_params)
    if @profile.save
      redirect_to users_basic_path(current_user), flash: { notice: "プロフィールを保存しました。" }
    else
      render :edit
    end
  end

  private

    def profile_form_params
      params.require(:profile_form).permit(:affiliation, :school, :faculty, :department, :laboratory, :content).merge(user_id: current_user.id)
    end

    # 他人のプロフィールを編集できないようにする
    def restricted_profile_editing
      redirect_to users_basic_path(current_user) if current_user&.profile != Profile.find(params[:id])
    end

end
