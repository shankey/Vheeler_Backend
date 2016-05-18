class AddColumnStatusTableCampaignInfo < ActiveRecord::Migration
  def change
  	add_column :campaign_infos, :status, :integer, :default => 1
  end
end
