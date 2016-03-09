class CreateAreas < ActiveRecord::Migration
  def change
    create_table :areas do |t|
      t.integer :ared_id
      t.decimal :latitude
      t.decimal :longitude

      t.timestamps null: false
    end
  end
end
