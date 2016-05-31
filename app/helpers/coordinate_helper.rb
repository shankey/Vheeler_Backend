module CoordinateHelper

	def get_previous_coordinate (co)
        enddate = co.recordtime
        startdate = enddate.to_date

        co_prev = Coordinate.where("recordtime > :startdate AND recordtime <= :enddate AND device_id = :device_id", {startdate: startdate, enddate: enddate, device_id: co.device_id}).order(recordtime: :desc).limit(1).take
        # sql = "SELECT id, latitude, longitude, polyline, recordtime,  ad_id, area_id, device_id, MAX(`coordinates`.`recordtime`) from `coordinates` WHERE (recordtime >= '%startdate' AND recordtime < '%enddate') AND (device_id = '%device_id')"
        # sql.sub! '%startdate', startdate.to_s
        # sql.sub! '%enddate', enddate.to_s
        # sql.sub! '%device_id', co.device_id 
        
        # arr = ActiveRecord::Base.connection.select_all(sql)
        # return get_coordinate_from_hash (arr[0])
        return co_prev
    end

    def get_coordinate_from_hash (arr)

    	if(arr['id'] == nil)
    		return nil
    	end

        co_prev = Coordinate.new
        co_prev.id = arr['id']
        co_prev.latitude = arr['latitude']
        co_prev.longitude = arr['longitude']
        co_prev.area_id = arr['area_id']
        co_prev.polyline = arr['polyline']
        co_prev.ad_id = arr['ad_id']
        co_prev.recordtime = DateTime.parse(arr['recordtime'])
        co_prev.device_id = arr['device_id']

        logger.info co_prev.inspect
        return co_prev
    end

    def calculate_time_and_distance (co_prev, co)
        logger.info "get_timeanddistance " 
        logger.info co.inspect
        run=true
        if(co_prev == nil || co_prev.polyline == nil || co_prev.polyline.empty?)
            poly_id = get_polyline(co.recordtime, get_unique_string)
        else
            poly_id = co_prev.polyline
        end
        
    	if(co_prev == nil) #first coordinate
                    #do nothing. First coordinate.
                    #add_time_and_distance(curr_coordinate, last_coordinate)
        elsif(((co.recordtime - co_prev.recordtime) > 120)) 
                    # coordinate came after 2 minutes so a new polyline. Not sure what happened in these 2 minutes. This should never happen 
                    poly_id = get_polyline(co.recordtime, get_unique_string)
                    logger.info ("LOST-COORDINATE" + co.to_s)
               
        logger.info "before calling"
        logger.info co.inspect     
        elsif(get_user_id_from_coordinate(co_prev.campaign_info_id) != get_user_id_from_coordinate(co.campaign_info_id)) # ad change 
                    poly_id = get_polyline(co.recordtime, get_unique_string)
                    run=add_time_and_distance(co,co_prev)
        else
                    run=add_time_and_distance(co,co_prev)
        end

        co.polyline = poly_id
        co.processed = 1

        return run

    end


    def add_time_and_distance(curr_coordinate, last_coordinate)
        logger.info "insdie add time and distance"
        point_a = Geokit::LatLng.new(last_coordinate.latitude, last_coordinate.longitude)
        point_b = Geokit::LatLng.new(curr_coordinate.latitude, curr_coordinate.longitude)
        
        time = curr_coordinate.recordtime - last_coordinate.recordtime
        distance = point_a.distance_to(point_b, options = {:units=>:kms})
        
        ci = CampaignInfo.where(id: curr_coordinate.campaign_info_id).take
        CampaignRun.where(campaign_info_id: ci.id).where(date: curr_coordinate.recordtime.to_date).update_all("exhausted_time = exhausted_time+" + time.to_s + "," + "distance = distance+" + distance.to_s)
        
        cr = CampaignRun.where(campaign_info_id: ci.id).where(date: curr_coordinate.recordtime.to_date).take
        
        if(cr.exhausted_time < cr.total_time)
            return true
        else
            return false
        end
    end

    def get_user_id_from_coordinate (campaign_info_id)

        ##validation
        if(campaign_info_id == nil)
            return nil
        end

        logger.info "get_userid for campaign_info_id = " + campaign_info_id.to_s 

        c = Campaign.joins(:campaign_info).includes(:campaign_info).where(:campaign_infos => {:id => campaign_info_id, :active => 1}).take;
    	return c.user_id
    end



    def get_polyline (date, unique_string)
        date.strftime("%m_%d_%y") + "_" + unique_string
    end

    def get_unique_string
        SecureRandom.urlsafe_base64 10
    end
end
