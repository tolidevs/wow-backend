class SubscriptionsController < ApplicationController

    def create
        if !Subscription.all.find{|subscription| subscription.user_id == params[:user] && subscription.imdbID == params[:imdbID]}
            @subscription = Subscription.create(user_id: params[:user], imdbID: params[:imdbID], title: params[:title], subscription_type: params[:type], year: params[:year], poster: params[:poster])
            render json: @subscription
        elsif Subscription.all.find{|subscription| subscription.user_id == params[:user] && subscription.imdbID == params[:imdbID]}
            render json: {message: "already saved"}
        else
            render json: {message: "error: failed to save"}
        end
    end

    def destroy
        subscription = Subscription.all.find_by(id: params[:id])
        subscription.delete
        render json: {message: "#{subscription.title} removed from saved list"}
    end
    
end
