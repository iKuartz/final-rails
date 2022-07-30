class AddAvailableOnDateRefToHotels < ActiveRecord::Migration[7.0]
  def change
    add_reference :hotels, :available_on_date, null: false, foreign_key: true
  end
end
