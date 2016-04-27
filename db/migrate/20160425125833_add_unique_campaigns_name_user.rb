class AddUniqueCampaignsNameUser < ActiveRecord::Migration
  def change
  	add_index :campaigns, [:user_id, :name], :unique => true
  	add_index :campaign_infos, [:ad_id, :area_id, :campaign_id], :unique => true
  	add_index :campaign_runs, [:campaign_info_id, :date], :unique => true
  end
end
