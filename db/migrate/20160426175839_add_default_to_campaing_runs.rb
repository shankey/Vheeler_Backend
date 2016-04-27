class AddDefaultToCampaingRuns < ActiveRecord::Migration
  def change
  	change_column :campaign_runs, :total_time, :decimal, :precision => 10, :scale => 2, :default => 0.00
  	change_column :campaign_runs, :distance, :decimal, :precision => 10, :scale => 2, :default => 0.00
  end
end
