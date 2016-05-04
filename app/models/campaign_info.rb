class CampaignInfo < ActiveRecord::Base
	belongs_to :campaign
	belongs_to :ad
	has_many :campaign_run

	def self.get_all_active_campaigns
		all_active_campaigns=CampaignInfo.joins(:campaign, :ad).includes(:campaign, :ad).where('campaigns.active=1')
    	return all_active_campaigns
	end
end
