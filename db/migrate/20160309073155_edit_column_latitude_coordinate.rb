class EditColumnLatitudeCoordinate < ActiveRecord::Migration
  def change
    change_column :coordinates, :latitude, :decimal, :precision => 15, :scale => 10
  end
end
