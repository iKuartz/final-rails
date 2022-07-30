class AddAddressRefToHotels < ActiveRecord::Migration[7.0]
  def change
    add_reference :hotels, :address, null: false, foreign_key: true
  end
end
