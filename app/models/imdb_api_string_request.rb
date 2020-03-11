require 'net/http'
require 'open-uri'
require 'json'

class ImdbApiStringRequest

    attr_reader :search_params

    def initialize(search_params)
        @search_string = search_params[:search_string]
    end

    def create_url_string
        base_url = "https://movie-database-imdb-alternative.p.rapidapi.com/?r=json&s="

        parsed_search_string = @search_string.gsub(" ", "%20")
        
        @url="#{base_url}#{parsed_search_string}"
    end

    def get_shows
        # uri = URI.parse(create_url_string)
        # response = Net::HTTP.get_response(uri)
        # p response.body
        url = URI(create_url_string)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'movie-database-imdb-alternative.p.rapidapi.com'
        request["x-rapidapi-key"] = ENV['IMDB_API_KEY']

        response = http.request(request)
        p JSON.parse(response.read_body)
    end

    def create_show_objects
        api_response = get_shows["Search"]
        objects_array = api_response.map { |show| 
            {imdbID: show["imdbID"], title: show["Title"], type: show["Type"], poster: show["Poster"], services: []} 
        }
        p objects_array
    end



end
