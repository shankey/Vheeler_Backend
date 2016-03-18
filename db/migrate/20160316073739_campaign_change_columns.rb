class CampaignChangeColumns < ActiveRecord::Migration
  def change
    change_column :campaigns, :user_id,:integer
    remove_column :campaigns, :integer
  end
end
