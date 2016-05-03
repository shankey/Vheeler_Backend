class CampaignInfo < ActiveRecord::Base

	def self.get_all_active_campaigns
		sql = "LEFT JOIN campaigns ON campaign_infos.campaign_id=campaigns.id where campaigns.active=1"

    	all_active_campaigns = CampaignInfo.joins(sql).all
    	return all_active_campaigns
	end
end
