# frozen_string_literal: true

class Searches::UsersController < ApplicationController
  before_action :authenticate_user!

  # ユーザーの検索一覧を表示
  def index
    # URLで検索した場合は全件表示する
    @profiles = Profile.all if params[:q].nil?

    # 検索ボタンを押して検索した場合
    # 加えて、contentカラムを使って検索した場合
    if !params[:q][:content_cont].empty?
      split_keywords = params[:q][:content_cont].split(/[[:blank:]]+/) # キーワードを分割して格納する
      if !split_keywords.empty? # キーワードが空でない場合は一つずつ検索する
        split_keywords.each do |keyword|
          @keyword_targets = Profile.where('content LIKE(?)', "%#{keyword}%")
        end
      else # キーワードに空白(スペース)のみ入力されていた場合は検索しない
        @keyword_targets = []
      end

      # content以外のカラムに値が入っていれば、そこからプロフィールを検索する
      # params[:q][:content]を無視して検索したいので空にする
      params[:q][:content_cont] = ""

      # content以外のカラムで得た結果を@general_targetsと定義する
      @general_targets = Profile.ransack(params[:q]).result

      # contentとcontent以外で得たプロフィールから共通するデータを選出する
      @keyword_targets.each do |k_target|
        @general_targets.each do |g_target|
          if k_target == g_target
            @profiles = Profile.where(id: k_target)
          end
        end
      end
    else 
      # contentカラムを使わず検索した場合
      @q = Profile.ransack(params[:q])
      @profiles = @q.result.page(params[:page])
    end
  end

end
