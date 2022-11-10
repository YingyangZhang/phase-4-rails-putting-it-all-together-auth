class UsersController < ApplicationController
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_data
    before_action :authorize, only: [:show]

    def create
        user = User.create!(user_params)
        session[:user_id] = user.id
        render json: user, status: :created
    end

    def show
        user = User.find_by(id: session[:user_id])
        render json: user
    end

    private

    def user_params
        params.permit(:username, :password, :password_confirmation, :image_url, :bio)
    end

    def invalid_data(e)
        render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end

    def authorize
        return render json: {error: "Not authorized"}, status: :unauthorized unless session.include? :user_id
    end
end
