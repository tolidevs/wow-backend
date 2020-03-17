class SavedShowController < ApplicationController

    def create
        @saved_show = SavedShow.create(user_id: )
    end
end
