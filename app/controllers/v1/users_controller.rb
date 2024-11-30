module V1
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_user, only: [:update, :destroy ]

    rescue_from ActiveRecord::RecordNotFound, with: :users_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :user_invalid
    rescue_from StandardError, with: :handle_user_error

    # def index
    #   @users = User.all
    # end

    # def show
    # end

    # def new
    #   @user = User.new
    # end

    # def edit
    # end

    def create
      @user = User.new(user_params)
      Rails.logger.debug "パラメータ確認1 #{user_params}"

      if @user.save
        log_in @user
        render json: {
          id: @user.id,
          name: @user.name,
          email: @user.email,
          password_digest: @user.password,
          profile_photo: @user.profile_photo_url,
          cover_photo: @user.cover_photo_url
        }, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      if @user.update(user_params)
        redirect_to user_url(@user), notice: "アカウントを編集しました。"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      begin
        @user = current_user
        password = params[:password]
        if @user.authenticate(password)
          if @user.destroy
            render json: {
              status: :success,
              message: "アカウントを削除しました",
            }, status: 201
          else
            render json: {
              status: :error,
              message: "アカウント削除中にエラーが発生しました",
            }, status: 401
          end
        else
          render json: {
            status: :error,
            message: "パスワードが正しくありません",
          }, status: 401
        end
      rescue => e
        Rails.logger.debug"アカウント削除確認 #{e}"
        render json: {
          status: :error,
          message: "アカウント削除処理エラー",
          errors: e.message
        }, status: 404
      end
    end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(#フロントの変数名と合わせる
        :name,
        :email,
        :password,
        :password_confirmation,
        :profile_photo,
        :cover_photo
      )
    end

    #エラーハンドリング
    def user_not_found
      render json: {
        status: :error,
        message: "ユーザーが見つかりません"
      }, status: :not_found
    end

    def user_invalid(e)
      render json: {
        status: :error,
        errors: e.message,
        details: e,
      }, status: :unprocessable_entity
    end

    def handle_user_error(e)
      render json: {
        status: :error,
        message: "ユーザー操作でエラーが発生しました",
        details: e,
      }, status: :internal_server_error
    end
  end
end