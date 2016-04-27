class RenameTableCampaignRun < ActiveRecord::Migration
  def change
  	rename_table :campaign_run, :campaign_runs
  end
end
