module V1
  class UsersController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :set_user, only: [:show, :edit, :update, :destroy ]

    rescue_from ActiveRecord::RecordNotFound, with: :users_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :user_invalid
    rescue_from StandardError, with: :handle_user_error

    def index
      @users = User.all
    end

    def show
    end

    def new
      @user = User.new
    end

    def edit
    end

    def create
      @user = User.new(user_params)
      Rails.logger.debug "パラメータ確認1 #{user_params}"

      if @user.save
        log_in @user
        # redirect_to user_url(@user), notice: "ログインしました。"
        render json: @user, status: :created
      else
        # render :new, status: :unprocessable_entity
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
      @user.destroy
      redirect_to users_url, notice: "アカウントを削除しました。", status: :see_other
    end

    private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
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