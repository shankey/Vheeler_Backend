class CampaignRun < ActiveRecord::Base
	belongs_to :campaign_info
	belongs_to :ad
	belongs_to :area

	def self.get_campaign_schedule(campaign_ids)
		campaign_schedules = CampaignRun.joins(:campaign_info => :campaign).includes(:campaign_info => :campaign).where(:campaigns => {:id => campaign_ids, :active => 1})
		
    	return campaign_schedules
	end

	def self.get_campaign_runs_by_campaign_info_ids (campaign_info_ids)
		CampaignRun.where(campaign_info_id: campaign_info_ids).all
	end
end
