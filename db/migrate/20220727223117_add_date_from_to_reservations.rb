class AddDateFromToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :date_from, :date
  end
end
