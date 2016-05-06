class AddColumnVersionTableCampaignInfo < ActiveRecord::Migration
  def change
  	add_column :campaign_infos, :version, :integer, :default => 1
  end
end
