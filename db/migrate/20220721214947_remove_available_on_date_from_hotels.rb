class RemoveAvailableOnDateFromHotels < ActiveRecord::Migration[7.0]
  def change
    remove_reference :hotels, :available_on_date, null: false, foreign_key: true
  end
end
