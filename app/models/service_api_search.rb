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
        JSON.parse(response.read_body)
        # working to here
    end

    # get data from api and map services if it has them
    def create_service_objects
        services = get_services
        services = services["collection"]["locations"]
        services_array = services.map { |service|  {name: service["display_name"], url: service["url"]} } if services.length > 0
        p services_array
    end

    # get back data of services, parse them into uniform results that can be mapped in front end
    def parse_service_objects
        services_array = create_service_objects
        # services_array = [{:name=> "iTunes", :url=> "https://itunes.apple.com/za/movie/casino-royale/id561902712"}, {:name=> "Google Play", :url=> "https://play.google.com/store/movies/details/Casino_Royale?gl=GB&hl=en&id=deA2fR9iFZw"}, {:name=> "iTunes", :url=> "https://itunes.apple.com/gb/movie/casino-royale/id561902712"}, {:name=> "IVA", :url=> nil }]

        services = if services_array
            services_array.map { |service| 
            name = service[:name].downcase
            case 
            when name.include?("iva")
                p nil
            when name.include?("netflix")
                service[:name] = "Netflix"
                p service
            when name.include?("itunes")
                service[:name]= "iTunes"
                p service
            when name.include?("amazon")
                p service[:name] = "Amazon"
                p service
            when name.include?("google play")
                p service
            when name.include?("disneyplus")
                service[:name] = "DisneyPlus"
                p service
            else
                service[:name] =  "other"
                p service
            end
        }
        end 
# tidy up remove nil and duplicates
        if services 
            services = services.compact
            services = services.uniq{ |service| service[:name]}
        end
        p services
    end

    # remove foreign services from iTunes & disney+
    def remove_foreign_services
        
    end
end