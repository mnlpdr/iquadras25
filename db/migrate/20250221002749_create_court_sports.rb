class CreateCourtSports < ActiveRecord::Migration[7.1]
  def change
    create_table :court_sports do |t|
      t.references :court, null: false, foreign_key: true
      t.references :sport, null: false, foreign_key: true
      t.timestamps
    end
    
    add_index :court_sports, [:court_id, :sport_id], unique: true
  end
end