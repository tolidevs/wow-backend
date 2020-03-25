require 'net/http'
require 'open-uri'
require 'json'

class ImdbIdSearch

    attr_reader :id

    def initialize(search_params)
        @imdbID = search_params[:imdbID]
    end

    def create_url_string
        @url="https://movie-database-imdb-alternative.p.rapidapi.com/?i=#{@imdbID}&r=json"
    end

    def get_show
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

    # get show, then create an object with its information
    def create_show_object
        show = get_show
        show_object = { 
            imdbID: show["imdbID"], 
            plot: show["Plot"], 
            genre: show["Genre"], 
            imdbRating: show["imdbRating"]
        }
        # cache_results(objects_array)
        p show_object
    end










# -------------cache for search results - doesn't work ------------

end
