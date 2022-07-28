class AddDateToToReservations < ActiveRecord::Migration[7.0]
  def change
    add_column :reservations, :date_to, :date
  end
end
