class ImagesController < ApplicationController
  before_action :set_user

  def update
    begin
      imageFlg = params[:user][:imageflg]

      update_image = case imageFlg.to_i
        when 1
          {profile_photo: params[:user][:profile_photo]}
        when 2
          {cover_photo: params[:user][:cover_photo]}
        else
          {}
      end

      if @user.update(update_image)
        image_url = imageFlg.to_i == 1 ? @user.profile_photo_url : @user.cover_photo_url
        render json: {
          status: :success,
          message: "画像がアップロードされました",
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
          message: "画像のアップロードが中断されました。",
        }, status: :unprocessable_entity
      end
    rescue => e
      render json: {
        status: :error,
        message: "画像編集処理でエラーが発生しました",
        item: e.message
      }, status: :internal_server_error
    end
  end

  private
  def set_user
    @user = current_user
    if @user.nil?
      render json: {
        status: :error,
        message: "ユーザーが見つかりません"
      }, status: :not_found
    end
  end

  # def image_params
  #   params.require(:user).permit(#フロントの変数名と合わせる
  #     :profile_photo,
  #     :cover_photo,
  #   )
  # end
end
