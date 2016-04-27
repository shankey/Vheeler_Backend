class ChangeTableColumnsCampaignInfo < ActiveRecord::Migration
  def change
  	rename_column :campaign_info, :time, :total_time
  	add_column :campaign_info, :days, :integer
  end
end
