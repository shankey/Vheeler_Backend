class CampaignController < ApplicationController

	skip_before_filter :verify_authenticity_token

	def get_all_campaigns
		all_campaigns = CampaignInfo.get_all_active_campaigns

		campaigns_hash = Hash.new
		ads_hash = Hash.new
		all_campaigns.each do |campaign|

			campaign_id = campaign.campaign_id

			if(campaigns_hash.key?(campaign_id))
				area_ads = campaigns_hash[campaign_id]
			else
				area_ads = Array.new
				campaigns_hash[campaign_id] = area_ads
			end
			
			area_ad = EntityAreaAd.new
			area_ad.areaId = campaign.area_id
			area_ad.adId = campaign.ad_id
			area_ads << area_ad

			ads_hash[campaign.ad.id] = campaign.ad.url
		end

		entity_campaigns_array = Array.new

		campaigns_hash.each do |key,value|
			puts key
			puts value
			ec = EntityCampaigns.new
			ec.campaignId = key
			ec.areaAds = value
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

		render :json => {:campaign => JSON.parse(entity_campaigns_array.to_json),
						:ads => JSON.parse(entity_ads_array.to_json)
						},
                :status => 200
	end

	def get_campaign_schedule
		obj = JSON.parse(params[:json], object_class: OpenStruct)
		campaign_ids = obj.campaignIds
		logger.info campaign_ids
		campaigns_hash = Hash.new
		campaign_runs = CampaignRun.get_campaign_schedule(campaign_ids)
		campaign_runs.each do |campaign_run|

			campaign_id = campaign_run.campaign_info.campaign.id

			if(campaigns_hash.key?(campaign_id))
				area_ads = campaigns_hash[campaign_id]
			else
				area_ads = Hash.new
				campaigns_hash[campaign_id] = area_ads
			end
			
			area_ad = EntityAreaAd.new
			area_ad.areaId = campaign_run.campaign_info.area_id
			area_ad.adId = campaign_run.campaign_info.ad_id

			if(area_ads.key?(area_ad))
				area_ad_schedule = area_ads[area_ad]
			else
				area_ad_schedule = Array.new
				area_ads[area_ad] = area_ad_schedule
			end

			sch = EntitySchedule.new
			sch.date = campaign_run.date
			sch.totalTime = campaign_run.total_time
			area_ad_schedule << sch

		end

		entity_campaigns_array = Array.new

		campaigns_hash.each do |key, value|
			logger.info key
			ec = EntityCampaigns.new
			ec.campaignId = key

			area_ads = Array.new
			value.each do |key, val|
				key.schedule = val
				area_ads << key
			end

			ec.areaAds = area_ads
			
			entity_campaigns_array << ec
		end

		render :json => {:campaign => JSON.parse(entity_campaigns_array.to_json),
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

	def get_active_campaigns
		obj = JSON.parse(params[:json], object_class: OpenStruct)
		sql = nil
		obj.campaigns.each do |campaign|
			if(sql != nil)
				sql = sql + " or "
			end
			sql_template = "(area_id=%area_id and ad_id=%ad_id and campaign_id=%campaign_id and date='%date')"
			sql_template.sub!('%area_id',campaign.areaId.to_s)
			sql_template.sub!('%ad_id',campaign.adId.to_s)
			sql_template.sub!('%campaign_id',campaign.campaignId.to_s)
			sql_template.sub!('%date',campaign.date.to_s)
			if(sql==nil)
				sql = sql_template
			else
				sql = sql + sql_template
			end
			
		end
		
		logger.info sql

		campaign_runs = CampaignRun.joins(:campaign_info).includes(:campaign_info).where(sql).all
		logger.info campaign_runs.inspect

		campaign_actives = Array.new
		campaign_runs.each do |cr|
			ca = EntityCampaignActive.new
			ca.campaignId = cr.campaign_info.campaign_id
			ca.areaId = cr.campaign_info.area_id
			ca.adId = cr.campaign_info.ad_id

			if(cr.exhausted_time>=cr.total_time)
				ca.active = 0
			else
				ca.active=1
			end
			campaign_actives << ca
		end


		render :json => {:campaignIds => JSON.parse(campaign_actives.to_json)},
                :status => 200
	end
end
