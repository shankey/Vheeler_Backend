class AddColumnTimestamp < ActiveRecord::Migration
  def change
    add_column :coordinates, :recordtime, :timestamp
  end
end
