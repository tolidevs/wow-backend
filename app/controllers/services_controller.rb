class ServicesController < ApplicationController

    def index
        @services = Service.all
        render json: @services, only: [:id, :name]
    end

end
