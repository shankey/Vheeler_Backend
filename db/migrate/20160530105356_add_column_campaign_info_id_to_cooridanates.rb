class AddColumnCampaignInfoIdToCooridanates < ActiveRecord::Migration
  def change
  	add_column :coordinates, :campaign_info_id, :integer
  end
end
