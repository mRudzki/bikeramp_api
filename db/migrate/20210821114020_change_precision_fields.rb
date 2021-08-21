class ChangePrecisionFields < ActiveRecord::Migration[6.1]
  def up
    change_column :trips, :distance, :decimal, precision: 8, scale: 3
    change_column :trips, :price, :decimal, precision: 8, scale: 2
  end

  def down
    change_column :trips, :distance, :decimal, precision: 3, scale: nil
    change_column :trips, :price, :decimal, precision: 2, scale: nil
  end
end
