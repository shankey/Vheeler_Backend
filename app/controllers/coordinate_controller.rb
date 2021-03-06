class CoordinateController < ApplicationController
    include CoordinateHelper

    skip_before_filter :verify_authenticity_token

    
    
    def coordinate
        logger.debug params

            obj = JSON.parse(params[:json], object_class: OpenStruct)
            logger.info obj
            if(obj==nil || obj.campaignInfoId==nil || obj.coordinate==nil || obj.coordinate.latitude==nil || obj.coordinate.longitude==nil || obj.timestamp==nil || obj.areaId==nil)

                render :json => {:run => false},
                :status => 200
                return

            end

                
                co = Coordinate.new
                co.latitude = obj.coordinate.latitude
                co.longitude = obj.coordinate.longitude
                co.area_id = obj.areaId
                co.ad_id = obj.adId
                co.recordtime = obj.timestamp
                co.device_id = obj.deviceId
                co.campaign_info_id = obj.campaignInfoId

                if(co.ad_id != 7)
                    run = process_coordinate(co)
                else
                    run=true
                end

                co.save

            render :json => {:run => run},
                :status => 200
    end

    def process_coordinate(co)
        co_prev = get_previous_coordinate(co)
        logger.info "previous coordinate " + co_prev.inspect
        run = calculate_time_and_distance(co_prev,co)
        return run

    end
    
    def coordinate_batch
        logger.debug params
            obj = JSON.parse(params[:json], object_class: OpenStruct)
            logger.info obj
            if(obj==nil || obj.li == nil)
                render :json => {:run => false},
                :status => 200
                return
            end
            
            obj.li.each do |o|
                if(obj.campaignInfoId!=nil && obj.coordinate!=nil && obj.coordinate.latitude!=nil && obj.coordinate.longitude!=nil && obj.timestamp!=nil && obj.areaId!=nil)
                    co = Coordinate.new
                    co.latitude = o.coordinate.latitude
                    co.longitude = o.coordinate.longitude
                    co.area_id = o.areaId
                    co.ad_id = o.adId
                    co.recordtime = o.timestamp
                    co.device_id = obj.deviceId
                    co.campaign_info_id = o.campaignInfoId
                
                    logger.info co.inspect
                    if(co.ad_id != 7)
                        process_coordinate(co)
                    else
                        run=true
                    end
                    co.save
                end
            end
            
            render :json => {:message => "Coordinate Batch Saved"},
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
