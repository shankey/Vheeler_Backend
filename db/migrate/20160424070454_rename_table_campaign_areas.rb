class RenameTableCampaignAreas < ActiveRecord::Migration
  def change
  	rename_table :campaign_areas, :campaign_info
  end
end
