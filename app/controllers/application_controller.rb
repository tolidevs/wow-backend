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
            token = auth_header
            # puts token
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
        shows = get_services(results.first(5))
        # p shows
        render json: shows
    end

    # format params for fetch on saved services pass to get services function then render json back to front end
    def get_saved_services
        array = params[:array]
        shows = get_services(array)
        render json: shows
    end
    # iterate through shows and call fetch services 
    def get_services(results_array)
        shows = results_array.map do |tv_show|
            fetch_services(tv_show)
        end
        shows
    end

    # fetch services for each show from API, update show object with services objects and return
    def fetch_services(tv_show)
        request = ServiceApiSearch.new(tv_show[:imdbID])
        services = request.parse_service_objects
        tv_show[:services] = services
        p tv_show
    end

    # fetch details from IMDB api to show in show page in front end
    def get_show_details
        request = ImdbIdSearch.new(params)
        show_obj = request.create_show_object
        render json: show_obj
    end
end
