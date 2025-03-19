class AddLatitudeAndLongitudeToCourts < ActiveRecord::Migration[7.0]
  def change
    add_column :courts, :latitude, :float, null: true  # Permite valores nulos
    add_column :courts, :longitude, :float, null: true # Permite valores nulos
  end
end
