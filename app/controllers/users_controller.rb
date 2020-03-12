class UsersController < ApplicationController
    # skip_before_action :authorized, only: [:create]

    def profile
        if current_user
          render json: { user: UserSerializer.new(current_user) }, status: :accepted
        else 
          render json: { error: "You are not Authorized" }
    end

    def create
      @user = User.create(user_params)
      if @user.valid?
        token = generate_token(user_id: @user.id)
        render json: { user: UserSerializer.new(@user), token: token }, status: :created
      else
        render json: { error: 'failed to create user' }, status: :not_acceptable
      end
    end

    
 
    private

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
end
