class RenameTableCampaignInfo < ActiveRecord::Migration
  def change
  	rename_table :campaign_info, :campaign_infos
  end
end
