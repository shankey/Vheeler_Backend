class AddColumnProcessedToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :processed, :integer
    add_column :ads, :time, :decimal, :precision => 10, :scale => 2
    add_column :ads, :distance, :decimal, :precision => 10, :scale => 4
  end
end
