class DropCoordinates < ActiveRecord::Migration
  def change
    if ActiveRecord::Base.connection.table_exists? :coordinates
      drop_table :coordinates
    end
    
  end
end
