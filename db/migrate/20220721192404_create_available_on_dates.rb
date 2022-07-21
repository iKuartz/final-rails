class CreateAvailableOnDates < ActiveRecord::Migration[7.0]
  def change
    create_table :available_on_dates do |t|
      t.date :date
      t.integer :rooms_occopied
      t.boolean :available
      t.integer :rooms_free

      t.timestamps
    end
  end
end
