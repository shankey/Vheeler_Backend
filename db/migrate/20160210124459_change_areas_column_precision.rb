class ChangeAreasColumnPrecision < ActiveRecord::Migration
  def change
    change_column :areas, :latitude, :decimal, :precision => 10, :scale => 3
    change_column :areas, :longitude, :decimal, :precision => 10, :scale => 3
  end
end
