require 'net/http'
require 'open-uri'
require 'json'

class ImdbApiStringRequest
    attr_reader :search_params

    def initialize(search_params)
        @search_string = search_params[:search_string]
    end

    # parse search string into a URL for API request
    def create_url_string
        base_url = "https://movie-database-imdb-alternative.p.rapidapi.com/?r=json&s="

        parsed_search_string = @search_string.gsub(" ", "%20")
        
        @url="#{base_url}#{parsed_search_string}"
    end

    # use search string to request shows from the API
    def get_shows
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

    # create an object for each show in format for front end and put in an array
    def create_show_objects
        api_response = get_shows["Search"]
        objects_array = api_response.map { |show| 
            {imdbID: show["imdbID"], title: show["Title"], show_type: show["Type"], year: show["Year"], poster: show["Poster"]} 
        }
        # cache_results(objects_array)

        # filter out game objects
        objects_array = objects_array.filter{ |show| show[:show_type] != "game" }

        p objects_array
    end









# -------------cache for search results - doesn't work ------------

    # add results to cache table?
    def cache_results(results_objects)
        new = results_objects.each { |result|
            CachedShow.all.find_by(:imdbID == result[:imdbID]) ? nil : create_cache(result) }
            # CachedShow.create(imdbID: result[:imdbID], title: result[:title], show_type: result[:type], year: result[:year], poster: result[:poster]) 
        
        p "complete"
    end

    def create_cache(result)
        CachedShow.create(imdbID: result[:imdbID], title: result[:title], show_type: result[:type], year: result[:year], poster: result[:poster])
    end
end
