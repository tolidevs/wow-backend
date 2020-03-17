class RenameColumnSavedShowsTypeToShowType < ActiveRecord::Migration[6.0]
  def change
    rename_column :saved_shows, :type, :show_type
  end
end
