class AddHotelsRefToAvailableOnDates < ActiveRecord::Migration[7.0]
  def change
    add_reference :available_on_dates, :hotel, null: false, foreign_key: true
  end
end
