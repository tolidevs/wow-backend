class User < ApplicationRecord
    has_many :subscriptions
    has_many :saved_shows
    has_secure_password
    validates :email, uniqueness: { case_sensitive: false }
    validates :name, :email { presence: true }

    skip_before_action :authorized, only: [:create]


    
    def create
        @user = User.create(user_params)
        if @user.valid?
        render json: { user: UserSerializer.new(@user) }, status: :created
        else
        render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end
 
    private

    def user_params
        params.require(:user).permit(:name, :email, :password)
    end
end
