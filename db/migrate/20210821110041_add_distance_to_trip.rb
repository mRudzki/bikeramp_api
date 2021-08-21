class AddDistanceToTrip < ActiveRecord::Migration[6.1]
  def up
    add_column :trips, :distance, :decimal, precision: 3
  end
end
