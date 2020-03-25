class SubscriptionsController < ApplicationController

    def create
        if !Subscription.all.find{|subscription| subscription.user_id == params[:user_id] && subscription.service_id == params[:service_id]}
            @subscription = Subscription.create(user_id: params[:user_id], service_id: params[:service_id])
            render json: @subscription
        elsif Subscription.all.find{|subscription| subscription.user_id == params[:user_id] && subscription.service_id == params[:service_id]}
            render json: {message: "already saved"}
        else
            render json: {message: "error: failed to save"}
        end
    end

    def destroy
        subscription = Subscription.all.find_by(id: params[:id])
        subscription.delete
        render json: {message: "#{subscription.id} removed"}
    end
    
end
