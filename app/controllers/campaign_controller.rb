class CampaignController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def get_active_campaigns
		obj = JSON.parse(params[:json], object_class: OpenStruct)
		campaignIds = obj.campaignIds

		campaigns = Campaign.where(id: campaignIds)

		active_campaign_ids = Array.new
		campaigns.each do |campaign|
			ecia = EntityCampaignIdActive.new
			ecia.campaignId = campaign.id
			ecia.active = campaign.active ? 1 : 0
			active_campaign_ids << ecia
		end

		render :json => {:expiredCampaigns => JSON.parse(active_campaign_ids.to_json)
						},
                :status => 200

	end

	def get_all_campaigns
		all_campaigns = CampaignInfo.get_all_active_campaigns

		campaigns_hash = Hash.new
		ads_hash = Hash.new
		all_campaigns.each do |campaign_info|

			campaign_id = campaign_info.campaign_id

			if(!campaigns_hash.key?(campaign_id))
				campaigns_hash[campaign_id] = Array.new
			end
			
			entity_campaign_info = EntityCampaignInfo.new
			entity_campaign_info.campaignInfoId = campaign_info.id
			entity_campaign_info.areaId = campaign_info.area_id
			entity_campaign_info.adId = campaign_info.ad_id
			entity_campaign_info.version = campaign_info.version
			entity_campaign_info.active = campaign_info.active
			campaigns_hash[campaign_id] << entity_campaign_info

			ads_hash[campaign_info.ad.id] = campaign_info.ad.url
		end

		entity_campaigns_array = Array.new

		campaigns_hash.each do |key,value|
			ec = EntityCampaigns.new
			ec.campaignId = key
			ec.campaignInfos = value
			entity_campaigns_array << ec
		end

		entity_ads_array = Array.new

		ads_hash.each do |key,value|
			puts key
			puts value
			ea = EntityAd.new
			ea.adId = key
			ea.url = value
			entity_ads_array << ea
		end

		render :json => {:campaigns => JSON.parse(entity_campaigns_array.to_json),
						:ads => JSON.parse(entity_ads_array.to_json)
						},
                :status => 200
	end

	def get_campaign_schedule
		obj = JSON.parse(params[:json], object_class: OpenStruct)
		campaignsInput = obj.campaignInfoIds
		logger.info "get_campaign_schedule input = " + campaignsInput.inspect

		campaign_info_ids = Array.new
		obj.campaignInfoIds.each do |campaign|
			campaign_info_ids << campaign.campaignInfoId
		end
		

		campaign_runs = CampaignRun.get_campaign_runs_by_campaign_info_ids(campaign_info_ids)
		logger.info campaign_runs.inspect

		campaing_info_id_hash = Hash.new
		
		campaign_runs.each do |campaign_run|
			schedule = EntitySchedule.new

			schedule.date = campaign_run.date
			schedule.totalTime = campaign_run.total_time
			
			if(campaing_info_id_hash.key?(campaign_run.campaign_info_id))
				campaing_info_id_hash[campaign_run.campaign_info_id] << schedule
			else
				campaing_info_id_hash[campaign_run.campaign_info_id] = Array.new
				campaing_info_id_hash[campaign_run.campaign_info_id] << schedule
			end
		end

		campaign_runs = Array.new
		campaing_info_id_hash.each do |key, value|
			campaign_run = EntityCampaignRun.new
			campaign_run.campaignInfoId = key
			campaign_run.schedule = value
			campaign_runs << campaign_run
		end		

		render :json => {:campaignSchedules => JSON.parse(campaign_runs.to_json),
						},
                :status => 200
	end

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

	def get_exhausted_campaign_runs
		obj = JSON.parse(params[:json], object_class: OpenStruct)
		campaignsInput = obj.campaignInfoIds
		logger.info "get_campaign_schedule input = " + campaignsInput.inspect

		sql = nil

		obj.exhaustedCampaignList.each do |exhausted_campaign|
			sql_template = "(campaign_info_id=%campaign_info_id and date='%date')"
			sql_template.sub!("%campaign_info_id", exhausted_campaign.campaignInfoId.to_s)
			sql_template.sub!("%date", exhausted_campaign.date.to_s)

			if(sql == nil)
				sql = sql_template
			else
				sql = sql + " or " + sql_template
			end
		end
		
		logger.info sql

		campaign_runs = nil
		if(sql != nil)
			campaign_runs = CampaignRun.where(sql).all
			logger.info campaign_runs.inspect

			campaign_actives = Array.new
			campaign_runs.each do |cr|
				ca = EntityCampaignActive.new
				ca.campaignInfoId = cr.campaign_info_id
				ca.date = cr.date

				if(cr.exhausted_time>=cr.total_time)
					ca.active = 0
				else
					ca.active=1
				end
				campaign_actives << ca
			end
		end

		render :json => {:exhaustedCampaignList => JSON.parse(campaign_actives.to_json)},
                :status => 200
	end
end
