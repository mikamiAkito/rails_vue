class ProfilesController < ApplicationController
  before_action :set_user

  def update
    begin
      if @user.update(profile_params)
        render json: {
          status: :success,
          message: "プロフィールが更新されました",
          id: @user.id,
          name: @user.name,
          email: @user.email,
          password_digest: @user.password,
          profile_photo: @user.profile_photo_url,
          cover_photo: @user.cover_photo_url
        }, status: :ok
      else
        render json: {
          status: :error,
          message: @user.errors.full_messages,
          code: 1
        }, status: 422
      end
    rescue => e
      Rails.logger.error "プロフィール編集エラー#{e.message}"
      render json: {
        status: :error,
        message: "プロフィール編集処理でエラーが発生しました",
        item: e.message
      }, status: 500
    end
  end

  private
  def set_user
    @user = current_user
    if @user.nil?
      render json: {
        status: :error,
        message: "ユーザーが見つかりません"
      }, status: 404
    end
  end

  def profile_params
    params.require(:user).permit(
      :name,
      :email,
    )
  end
end
