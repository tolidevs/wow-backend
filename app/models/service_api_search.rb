require 'net/http'
require 'open-uri'
require 'json'

class ServiceApiSearch

    attr_reader :search_params

    def initialize(id)
        @imdbID = id
    end

    def create_url_string
        @url="https://utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com/idlookup?country=UK&source_id=#{@imdbID}&source=imdb"
    end

    def get_services
        url = URI(create_url_string)

        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request["x-rapidapi-host"] = 'utelly-tv-shows-and-movies-availability-v1.p.rapidapi.com'
        request["x-rapidapi-key"] = ENV['UTELLY_API_KEY']

        response = http.request(request)
        p JSON.parse(response.read_body)
    end

    def create_service_objects
        services = get_services["collection"]["locations"]
        objects_array = services.map { |service| 
            {name: service["display_name"], url: service["url"]} 
        }
        p objects_array
    end

end