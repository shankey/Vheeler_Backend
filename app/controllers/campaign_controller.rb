class CampaignController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def campaign_ingest
		Campaign.transaction do
			obj = JSON.parse(params[:json], object_class: OpenStruct)
			logger.info obj
			# add a check if a campaign with this name already exists
			campaign = Campaign.new
			campaign.user_id = obj.userId
			campaign.name = obj.name
			campaign.start_date = Date.parse(obj.startDate)
			campaign.save!

			campaign = Campaign.where(name: obj.name).where(user_id: obj.userId).take
			logger.info campaign.inspect

			obj.ads.each do |ad|
				ci = CampaignInfo.new
				ci.campaign_id = campaign.id
				ci.area_id = ad.areaId
				ci.ad_id = ad.adId
				ci.total_time = ad.time
				ci.save!


				ci = CampaignInfo.where(campaign_id: campaign.id).where(area_id: ad.areaId).where(ad_id: ad.adId).take

				date = campaign.start_date 
				no_of_days = obj.noOfDays.to_i
				for index in 1..no_of_days
					cr = CampaignRun.new
					cr.campaign_info_id = ci.id
					cr.date = date
					date = date + 1
					cr.total_time = ci.total_time.to_f / obj.noOfDays.to_f
					cr.save!
				end
			end
		end

		# do exception handeling to return custom message
		render :json => {:message => "Digested"},
                :status => 200
	end
end
