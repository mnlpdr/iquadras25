class AddOwnerToCourts < ActiveRecord::Migration[8.0]
  def change
    add_reference :courts, :owner, foreign_key: { to_table: :users }
  end
end
