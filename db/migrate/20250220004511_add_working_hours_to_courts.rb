class AddWorkingHoursToCourts < ActiveRecord::Migration[8.0]
  def change
    add_column :courts, :working_hours, :string
  end
end
