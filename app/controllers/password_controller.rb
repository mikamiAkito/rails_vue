class PasswordController < ApplicationController
  before_action :set_user

  def update
    begin
      if @user.authenticate(password_params[:current_password])
        if password_params[:password] == password_params[:password_confirmation]
          if @user.update(password: password_params[:password])
            render json: {
              status: :success,
              message: "パスワードが更新されました",
            }, status: :ok
          else
            render json: {
              status: :error,
              message: @user.errors.full_messages,
              code: 1
            }, status: 422
          end
        else
          render json: {
            status: :error,
            message: "新しいパスワードと確認用パスワードが一致しません",
            code: 2
          }, status: 422
        end
      else
        render json: {
          status: :error,
          message: "現在のパスワードが正しくありません",
        }, status: 401
      end

    rescue => e
      Rails.logger.error "パスワード更新エラー#{e.message}"

      render json: {
        status: :error,
        message: "現在のパスワードが正しくありません",
        error: e.message,
      }, status: 500
    end
  end

  private
  def set_user
    @user = current_user
    if @user.nil?
      render json: {
        status: :error,
        message: "ユーザーが見つかりません",
      }, status: 404
    end
  end

  def password_params
    params.require(:user).permit(
      :current_password,
      :password,
      :password_confirmation
    )
  end
end
