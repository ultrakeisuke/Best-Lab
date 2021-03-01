# frozen_string_literal: true

class Users::ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :restricted_profile_editing, only: %i[edit update]
  before_action :restricted_guest_profile_editing, only: [:update]

  # プロフィール新規作成画面
  def new
    @profile_form = ProfileForm.new
  end

  # プロフィール作成
  def create
    @profile_form = ProfileForm.new
    @profile_form.assign_attributes(profile_form_params)
    if @profile_form.save
      redirect_to users_basic_path(current_user), flash: { notice: 'プロフィールを保存しました。' }
    else
      render :new
    end
  end

  # プロフィール編集画面
  def edit
    # ログインユーザーのプロフィール情報を取得
    @profile = Profile.find(params[:id])
    @profile_form = ProfileForm.new(@profile)
  end

  # プロフィール編集
  def update
    @profile = Profile.find(params[:id])
    @profile_form = ProfileForm.new(@profile)
    # 複数のattributeをまとめて更新
    @profile_form.assign_attributes(profile_form_params)
    if @profile_form.save
      redirect_to users_basic_path(current_user), flash: { notice: 'プロフィールを保存しました。' }
    else
      render :edit
    end
  end

  private

  def profile_form_params
    params.require(:profile_form).permit(:affiliation, :school, :faculty, :department, :laboratory, :description).merge(user_id: current_user.id)
  end

  # 他人のプロフィールを編集できないようにする
  def restricted_profile_editing
    redirect_to users_basic_path(current_user) if current_user.profile != Profile.find(params[:id])
  end

  # ゲストユーザーのプロフィールは編集できないようにする
  def restricted_guest_profile_editing
    if current_user.email == 'guest@example.com'
      redirect_to users_basic_path(current_user), alert: 'ゲストユーザーのプロフィールは編集できません。'
    end
  end
end
