class ReportController < ApplicationController
    
    
    
    def get_campaign_details
        response.headers['Access-Control-Allow-Origin'] = 'true'
        user_id = params[:userId]
        campaign = Campaign.where(user_id: user_id).first
        puts campaign.inspect
        campaign_areas = CampaignArea.where(campaign_id: campaign.id).all
        
        table_rows = Array.new
        
        run_time = 0
        run_distance = 0
        campaign_areas.each do |campaign_area|
            etar = EntityTableAreaReport.new
            
            etar.area = AreaInfo.where(area_id: campaign_area.area_id).first.area_info
            etar.imageUrl = Ad.find(campaign_area.ad_id).url
            etar.time = campaign_area.time
            etar.distance = campaign_area.distance
            
            run_time + run_time + campaign_area.time
            run_distance = run_distance + campaign_area.distance
            
            table_rows << etar
        end
        
        ecr = EntityCampaignReport.new
        ecr.tableReport = table_rows
        ecr.startDate = nil
        
        ecr.totalTime = campaign.time
        ecr.runTime = run_time
        ecr.runDistance = run_distance
        
        render :json => JSON.pretty_generate({:report => JSON.parse(ecr.to_json)}),
             :status => 200
        
    end
    
    def get_polylines
        response.headers['Access-Control-Allow-Origin'] = 'true'
        user_id = params[:userId]
        page_id = params[:pageId]
        startdate = Date.parse(params[:startDate])
        enddate = Date.parse(params[:endDate])
        campaign = Campaign.where(user_id: user_id).first
        
        campaign_areas = CampaignArea.where(campaign_id: campaign.id).all
        ad_ids = Array.new
        campaign_areas.each do |campaign_area|
            ad_ids << campaign_area.ad_id
        end
    
        
        coordinates = Coordinate.where("recordtime > :startdate AND recordtime <= :enddate", {startdate: startdate, enddate: enddate}).where(ad_id: ad_ids).order(polyline: :asc).order(recordtime: :asc).page(page_id).per(500)
        polyCoordinateMap = Hash.new
        
        coordinates.each do |co|
            if(!polyCoordinateMap.key?(co.polyline))
                polyCoordinateMap[co.polyline] = Array.new
            end
            arr = polyCoordinateMap[co.polyline]
            gmap_coo = EntityGmapCoordinate.new
            gmap_coo.id = co.id
            gmap_coo.lat = co.latitude
            gmap_coo.lng = co.longitude
            
                
            arr << gmap_coo
            
        end
        
        polyCoordinateMap.each do |key, arr|
            polyCoordinateMap[key] = arr.join(" ")
        end
        
        render :json => JSON.pretty_generate({:report => JSON.parse(polyCoordinateMap.to_json)}),
             :status => 200
        
    end
    
    def get_coordiante_info
        response.headers['Access-Control-Allow-Origin'] = 'true'
        co_id = params[:co_id]
        coo = Coordinate.find(co_id)
        
        eci = EntityCoordinateInfo.new
        eci.area = AreaInfo.where(area_id: coo.area_id).first.area_info
        eci.adUrl = Ad.find(coo.ad_id).url
        
        render :json => JSON.pretty_generate({:report => JSON.parse(eci.to_json)}),
             :status => 200
        
    end
end
