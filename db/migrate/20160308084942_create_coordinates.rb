class CreateCoordinates < ActiveRecord::Migration
  def change
    create_table :coordinates do |t|
      t.string :user_id
      t.decimal :latitude ,:precision => 15, :scale => 10
      t.integer :longitude ,:precision => 15, :scale => 10
      t.integer :ad_id

      t.timestamps null: false
    end
  end
end
