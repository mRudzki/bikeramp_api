class AddDefaultZeroToDistance < ActiveRecord::Migration[6.1]
  def up
    change_column_default :trips, :distance, default: 0.0
    change_column_null :trips, :distance, false, 0.0
  end

  def down
    change_column :trips, :distance, :decimal, default: nil, null: true, precision: 8, scale: 3
  end
end
