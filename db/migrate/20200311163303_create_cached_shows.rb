class CreateCachedShows < ActiveRecord::Migration[6.0]
  def change
    create_table :cached_shows do |t|
      t.string :imdbID
      t.string :title
      t.string :type
      t.string :poster
      t.text :plot
      t.string :genre
      t.string :imdbRating
      t.text :full_fetch_object
    end
  end
end
