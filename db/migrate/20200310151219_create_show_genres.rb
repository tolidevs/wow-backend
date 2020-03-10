class CreateShowGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :show_genres do |t|
      t.references :saved_show, null: false, foreign_key: true
      t.references :genre, null: false, foreign_key: true

      t.timestamps
    end
  end
end
