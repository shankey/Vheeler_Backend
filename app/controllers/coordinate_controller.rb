class CoordinateController < ApplicationController
    
    skip_before_filter :verify_authenticity_token
    
    def coordinate
        logger.debug params
       
            obj = JSON.parse(params[:json], object_class: OpenStruct)
            
            co = Coordinate.new
            co.latitude = obj.coordinate.latitude
            co.longitude = obj.coordinate.longitude
            co.area_id = obj.areaId
            co.ad_id = obj.adId
            co.recordtime = obj.timestamp
            co.save
            render :json => {:message => "Coordinate Saved"},
                :status => 200
    end
    
    def coordinate_batch
        logger.debug params
            obj = JSON.parse(params[:json], object_class: OpenStruct)
            obj.each do |o|
                puts o
            end
            render :json => {:message => "Coordinate Saved"},
                :status => 200
    end
    
    def coordinate_markers
        user_id = params[:user_d]
        ads = Ad.where(user_id: user_id)
        ad_ids = Array.new
        ads.each do |ad|
            ad_ids << ad.user_id
        end
        
        Coordinate.where(area_id: ad_ids).page(params[:page]).per(200)
        
    end
end
