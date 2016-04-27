class CoordinateController < ApplicationController
    include CoordinateHelper

    skip_before_filter :verify_authenticity_token

    
    
    def coordinate
        logger.debug params
       
            obj = JSON.parse(params[:json], object_class: OpenStruct)
            logger.info obj
            co = Coordinate.new
            co.latitude = obj.coordinate.latitude
            co.longitude = obj.coordinate.longitude
            co.area_id = obj.areaId
            co.ad_id = obj.adId
            co.recordtime = obj.timestamp
            co.device_id = obj.deviceId

            co_prev = get_previous_coordinate(co)
            logger.info "previous coordinate " + co_prev.inspect
            calculate_time_and_distance(co_prev,co)


            co.save
            render :json => {:message => "Coordinate Saved"},
                :status => 200
    end
    
    def coordinate_batch
        logger.debug params
            obj = JSON.parse(params[:json], object_class: OpenStruct)
            
            Coordinate.transaction do
                obj.li.each do |o|
                    co = Coordinate.new
                    co.latitude = o.coordinate.latitude
                    co.longitude = o.coordinate.longitude
                    co.area_id = o.areaId
                    co.ad_id = o.adId
                    co.recordtime = o.timestamp
                    co.device_id = obj.deviceId
                    Coordinate.create(co.attributes)
                end
            end
            render :json => {:message => "Coordinate Saved"},
                :status => 200
    end
    
    def coordinate_markers
        user_id = params[:user_id]
        ads = Ad.where(user_id: user_id)
        ad_ids = Array.new
        ads.each do |ad|
            ad_ids << ad.user_id
        end
        
        Coordinate.where(area_id: ad_ids).page(params[:page]).per(1000)
        
    end
end
