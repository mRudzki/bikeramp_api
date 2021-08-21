class CreateTrips < ActiveRecord::Migration[6.1]
  def change
    create_table :trips do |t|
      t.string :start_address, null: false
      t.string :destination_address, null: false
      t.decimal :price, null: false, precision: 2
      t.date :date, null: false
      t.timestamps
    end
    add_index :trips, :date
  end

  def down
    drop_table :trips
  end
end
