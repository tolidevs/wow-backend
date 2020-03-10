class ShowGenre < ApplicationRecord
  belongs_to :saved_show
  belongs_to :genre
end
