class AddColumnDeviceIdToCoordinates < ActiveRecord::Migration
  def change
    add_column :coordinates, :device_id, :string
  end
end
