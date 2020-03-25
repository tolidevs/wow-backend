class AddColumnToSavedShows < ActiveRecord::Migration[6.0]
  def change
    add_column :saved_shows, :year, :string
    add_reference :saved_shows, :user, null: false, foreign_key: true
  end
end
