class EditColumnLongitudeCoordinate < ActiveRecord::Migration
  def change
    change_column :coordinates, :longitude, :decimal, :precision => 15, :scale => 10
  end
end
