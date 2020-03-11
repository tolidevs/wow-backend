class ApplicationController < ActionController::API
    before_action :authorized

    # secret from env file
    def secret
        ENV["MY_SECRET"]
    end

    # generate a token
    def generate_token(data)
        JWT.encode(data, secret)
    end

    def auth_header
        request.headers['Authorization']
    end

    # take the token from the request headers, if there is a token decode it, otherwise return nil
    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]
            puts token
            begin
                JWT.decode(token, secret, true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    # find furrent user by ID from decoded token
    def current_user
        if decoded_token
            user_id = decoded_token[0]['user_id']
            @user = User.find_by(id: id)
        end
    end

    # is there a current user logged in?
    def logged_in?
        !!current_user
    end

    def authorized
        render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end



    # ---------- API requests ------------
# need to update for final object to return to front end - currently only returning all results
    def search_shows
        request = ImdbApiStringRequest.new(params)
        results = request.get_shows
        render json: results
    end
end
