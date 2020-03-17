class SavedShowSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :imdbID, :title, :show_type, :year, :poster
end
