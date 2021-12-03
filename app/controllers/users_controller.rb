class UsersController < ApplicationController
rescue_from ActiveRecord::RecordInvalid, with: :render_invalid 

  def create
        user = User.create(user_params)
        if user.valid?
         session[:user_id] = user.id
         render json: user, status: :created
        else
         render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
  end   

    def show 
        if current_user
            render json: current_user, status: :ok 
        else
            render json: "Invalid Credentials. Try again!", status: :unauthorized
        end
    end

      private

    def user_params
        params.permit(:username, :password, :password_confirmation)
    end

    def render_invalid(invalid) 
        render json: {errors: invlaid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def current_user
        @user = User.find_by(id: session[:user_id])
    end

end
