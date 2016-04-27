class AddColumnDistanceToCampaignRuns < ActiveRecord::Migration
  def change
  	add_column :campaign_runs, :distance, :decimal, :precision => 10, :scale => 2
  end
end
