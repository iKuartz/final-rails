class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.integer :reserved_rooms
      t.date :date

      t.timestamps
    end
  end
end
