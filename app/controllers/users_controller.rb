class UsersController < ApplicationController

    def profile
        @user = current_user
        if @user
          render json: { user: UserSerializer.new(@user), token: generate_token(user_id: @user.id) }, status: :accepted
        else 
          render json: { error: "You are not Authorized" }
        end
    end

    def create
      @user = User.create(name: params[:name], email: params[:email], password: params[:password])
      if @user
        token = generate_token(user_id: @user.id)
        render json: { user: UserSerializer.new(@user), token: token }, status: :created
      else
        render json: { message: 'Failed to create user' }, status: :not_acceptable
      end
    end

    def get_saved_shows
      @user = User.all.find_by(id: params[:user_id])
      if @user
        user_shows = SavedShow.all.select{|show| show.user_id == @user.id}
        render json: user_shows
      end
    end
 
    private

    # def user_params
    #     params.require(:user).permit(:name, :email, :password)
    # end
end
