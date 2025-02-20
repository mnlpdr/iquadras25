class CreateCourtSports < ActiveRecord::Migration[8.0]
  def change
    create_table :court_sports do |t|
      t.references :court, null: false, foreign_key: true
      t.references :sport, null: false, foreign_key: true

      t.timestamps
    end
  end
end
