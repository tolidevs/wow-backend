class SavedShow < ApplicationRecord
    has_many :show_genres
    has_many :genres, through: :show_genres
end
