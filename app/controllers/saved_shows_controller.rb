class SavedShowsController < ApplicationController

    def create
        if !SavedShow.all.find{|show| show.user_id == params[:user] && show.imdbID == params[:imdbID]}
            @saved_show = SavedShow.create(user_id: params[:user], imdbID: params[:imdbID], title: params[:title], show_type: params[:type], year: params[:year], poster: params[:poster])
            render json: @saved_show
        elsif SavedShow.all.find{|show| show.user_id == params[:user] && show.imdbID == params[:imdbID]}
            render json: {message: "already saved"}
        else
            render json: {message: "error: failed to save"}
        end
    end

    def delete
        saved_show = SavedShow.all.find{|show| show.user_id == params[:user] && show.imdbID == params[:imdbID]}
        saved_show.delete
        render json: {message: "#{saved_show.title} removed from saved list"}
    end

end
