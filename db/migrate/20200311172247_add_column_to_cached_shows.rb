class AddColumnToCachedShows < ActiveRecord::Migration[6.0]
  def change
    add_column :cached_shows, :year, :string
  end
end
