class ChangeTableCampaigns < ActiveRecord::Migration

  def change
  	add_column :campaigns, :active, :boolean, :default => false
    remove_column :campaigns, :time
  end
end
