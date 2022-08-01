class CreateAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :addresses do |t|
      t.string :country
      t.string :state
      t.string :city
      t.string :neighbourhood
      t.string :street
      t.integer :number
      t.string :complement

      t.timestamps
    end
  end
end
