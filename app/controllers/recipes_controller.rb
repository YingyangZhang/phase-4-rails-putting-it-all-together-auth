class RecipesController < ApplicationController
    before_action :authorize
    rescue_from ActiveRecord::RecordInvalid, with: :invalid_data

    def index
        recipes = Recipe.all
        render json: recipes
    end

    def create
        user = User.find_by(id: session[:user_id])
        recipe = user.recipes.create!(recipe_params)
        render json: recipe, status: :created
    end
    
    private

    def recipe_params
        params.permit(:title, :instructions, :minutes_to_complete)
    end

    def authorize
        return render json: {errors: ["Not authorized"]}, status: :unauthorized unless session.include? :user_id
    end

    def invalid_data(e)
        render json: {errors: e.record.errors.full_messages}, status: :unprocessable_entity
    end
end
