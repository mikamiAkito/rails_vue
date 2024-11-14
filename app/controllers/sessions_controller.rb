class SessionsController < ApplicationController
  def create
    begin
      @user = User.find_by(email: params[:session][:email].downcase)
      # bcrypt の authenticateメソッドでパスワードの照合を行なう
      if @user&.authenticate(params[:session][:password])#&.を使用してnilチェック
        log_in(@user)
        render json: {
          status: :success,
          message: "ログインに成功しました",
          id: @user.id,
          name: @user.name,
          email: @user.email,
          password_digest: @user.password_digest,
          profile_photo: @user.profile_photo_url,
          cover_photo: @user.cover_photo_url,
          created_at: @user.created_at,
          updated_at: @user.updated_at
        }, status: :ok
      else
        render json: {
          status: :error,
          message: "ログインに失敗しました",
        }, status: :unauthorized
      end

    rescue => e
      render json: {
        status: :error,
        item: e,
        message: "ログイン中に予期せぬエラーが発生しました"
      }, status: :internal_server_error
    end
  end

  def destroy
    begin
      if logged_in?
        log_out
        render json: {
          status: :success,
          message: "ログアウトしました"
        }, status: :ok
      else
        render json: {
          status: :error,
          message: "既にログアウトしています"
        }, status: :bad_request
      end
    rescue => e
      Rails.logger.error "ログアウトエラー#{e.message}"
      render json: {
        status: :error,
        item: e,
        message: "ログアウト処理中にエラーが発生しました"
      }, status: :internal_server_error
    end
  end
end
