class AdsController < ApplicationController
    
    def ads
        puts params
        ads = Ad.all
        entity_ads = Array.new
        ads.each do |ad|
            entity_ad = EntityAd.new
            entity_ad.areaId = ad.area_id
            entity_ad.url = ad.url
            
            entity_ads << entity_ad
        end
        render :json => JSON.pretty_generate({:ads => JSON.parse(entity_ads.to_json)}),
             :status => 200
    end
end
