class CreateSavedShows < ActiveRecord::Migration[6.0]
  def change
    create_table :saved_shows do |t|
      t.string :imdbID
      t.string :title
      t.string :type
      t.string :poster
      

      t.timestamps
    end
  end
end
