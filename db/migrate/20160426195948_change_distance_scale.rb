class ChangeDistanceScale < ActiveRecord::Migration
  def change
  	change_column :campaign_runs, :distance, :decimal, :precision => 10, :scale => 5
  end
end
