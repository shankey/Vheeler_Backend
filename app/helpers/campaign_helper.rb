module CampaignHelper

	def get_default_ad
		default_ad = Ad.where(id: 7).take  
		default_entity_ad = EntityAd.new
		default_entity_ad.adId = default_ad.id
		default_entity_ad.url = default_ad.url
		return default_entity_ad
	end
end
