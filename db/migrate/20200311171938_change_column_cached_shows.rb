class ChangeColumnCachedShows < ActiveRecord::Migration[6.0]
  def change
    rename_column :cached_shows, :type, :show_type
  end
end
