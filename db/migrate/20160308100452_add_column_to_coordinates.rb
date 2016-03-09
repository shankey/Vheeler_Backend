class AddColumnToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :area_id, :integer
  end
end
