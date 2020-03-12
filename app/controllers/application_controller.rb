class ApplicationController < ActionController::API
    # before_action :authorized

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

    # check whether there is an authorization header in the request
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
            @user = User.find_by(id: user_id)
        end
    end

    # # is there a current user logged in?
    # def logged_in?
    #     !!current_user
    # end

    # def authorized
    #     render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    # end



    # ---------- API requests ------------
    # create an API request, create show objects, pass into get_services function to do another API request to 
    # retreive the services then update the objects and return objects to front end
    # request params structure : {search_params: "string"}
    def search_shows
        request = ImdbApiStringRequest.new(params)
        results = request.create_show_objects
        shows = get_services(results)
        p shows
        # render json: shows
    end

    # iterate through shows and call fetch services
    def get_services(results_array)
        shows = results_array.map do |show|
            fetch_services(show)
        end
        shows
    end

    # fetch services for each show from API, update show object with services objects and return
    def fetch_services(show)
        request = ServiceApiSearch.new(show[:imdbID])
        services = request.create_service_objects
        show[:services] = services
    end
end
