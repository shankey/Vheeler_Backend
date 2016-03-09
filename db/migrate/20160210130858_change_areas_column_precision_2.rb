class ChangeAreasColumnPrecision2 < ActiveRecord::Migration
  def change
    change_column :areas, :latitude, :decimal, :precision => 13, :scale => 10
    change_column :areas, :longitude, :decimal, :precision => 13, :scale => 10
  end
end
