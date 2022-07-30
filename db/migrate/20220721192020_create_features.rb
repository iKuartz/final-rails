class CreateFeatures < ActiveRecord::Migration[7.0]
  def change
    create_table :features do |t|
      t.integer :room
      t.boolean :pool
      t.boolean :bar
      t.boolean :air_conditioning
      t.boolean :tv
      t.boolean :gym

      t.timestamps
    end
  end
end
