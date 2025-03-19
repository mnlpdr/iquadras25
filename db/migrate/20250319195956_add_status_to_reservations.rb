class AddStatusToReservations < ActiveRecord::Migration[7.1]
  def change
    add_column :reservations, :status, :integer, default: 0
    add_index :reservations, :status
  end
end
