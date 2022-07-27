class AddFeatureRefToHotels < ActiveRecord::Migration[7.0]
  def change
    add_reference :hotels, :feature, null: false, foreign_key: true
  end
end
