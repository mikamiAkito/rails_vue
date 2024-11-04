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
          user: @user
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
    log_out
    redirect_to root_path, status: :see_other
  end
end
