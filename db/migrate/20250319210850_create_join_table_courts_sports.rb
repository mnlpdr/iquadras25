class CreateJoinTableCourtsSports < ActiveRecord::Migration[7.1]
  def change
    create_join_table :courts, :sports do |t|
      t.index [:court_id, :sport_id]
      t.index [:sport_id, :court_id]
    end
  end
end