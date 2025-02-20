class AddPricePerHourToCourts < ActiveRecord::Migration[7.1]
  def change
    add_column :courts, :price_per_hour, :decimal, precision: 10, scale: 2
  end
end