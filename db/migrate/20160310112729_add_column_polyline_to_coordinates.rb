class AddColumnPolylineToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :polyline, :string
  end
end
