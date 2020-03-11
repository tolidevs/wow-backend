require 'net/http'
require 'open-uri'
require 'json'

class ImdbIdSearch

    attr_reader :search_params

    def initialize(id)
        @imdbID = id
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

    # do something with data that comes back!
    def create_show_objects
        api_response = get_show
        objects_array = api_response.map { |show| 
            {imdbID: show["imdbID"], title: show["Title"], type: show["Type"], year: show["Year"], poster: show["Poster"], services: []} 
        }
        # cache_results(objects_array)
        p objects_array
    end










# -------------cache for search results - doesn't work ------------

end
