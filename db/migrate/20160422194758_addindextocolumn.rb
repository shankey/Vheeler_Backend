class Addindextocolumn < ActiveRecord::Migration
  def change
  	add_index :coordinates, [:device_id, :recordtime]
  end
end
