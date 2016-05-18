class RenameColumnStatusTableCampaignInfo < ActiveRecord::Migration
  def change
  	rename_column :campaign_infos, :status, :active
  end
end
