class ApplicationController < ActionController::API

    def secret
        ENV["MY_SECRET"]
    end
end
