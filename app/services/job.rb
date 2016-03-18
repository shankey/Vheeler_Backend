class Job

    def daily_report_aggregator_job (startdate, enddate)
        
        ############# select all device_ids of vehicles ############
        a_device_ids = Coordinate.where("recordtime > :startdate AND recordtime <= :enddate", {startdate: startdate, enddate: enddate}).select(:device_id).uniq
        
        device_ids = Array.new
        a_device_ids.each do |obj|
            device_ids << obj.device_id
        end
        
        puts device_ids
        ############# ################################# ############
        
        ############# select all ad_ids of vehicles ############
        # user_id = params[:user_d]
        # ads = Ad.where(user_id: user_id)
        # ad_ids = Array.new
        # ads.each do |ad|
        #     ad_ids << ad.user_id
        # end
        ############# ################################# ############
        
        ############# select all coordinates per car ###############
        device_ids.each do |device_id|
            car_coordinates = Coordinate.where("device_id = ?", device_id).order(recordtime: :asc)
            number = 1
            
            last_coordinate = nil;
            car_coordinates.each do |coo|
                #coo.user_id = get_user_id_for_coordinate(coo)
                
                curr_coordinate = coo
                if(last_coordinate == nil) #first coordinate
                    #do nothing. First coordinate.
                    #add_time_and_distance(curr_coordinate, last_coordinate)
                elsif(((curr_coordinate.recordtime - last_coordinate.recordtime)/60 > 2)) 
                    # coordinate came after 2 minutes so a new polyline. Not sure what happened in these 2 minutes. This should never happen 
                    number = number + 1
                    puts ("LOST-COORDINATE" + curr_coordinate.id.to_s)
                    
                elsif(curr_coordinate.user_id != last_coordinate.user_id) # ad change 
                    number = number + 1
                    add_time_and_distance(curr_coordinate, last_coordinate)
                else
                    add_time_and_distance(curr_coordinate, last_coordinate)
                end
                
                coo.polyline = get_polyline(startdate, curr_coordinate.device_id, number)
                coo.processed = 1
                
                coo.save
                last_coordinate = curr_coordinate
            end
        end
        
        ############# ################################# ############
        
    end
    
    def get_polyline (date, device_id, number)
        date.strftime("%m_%d_%y") + "_" + device_id + "_" + number.to_s
    end
    
    def add_time_and_distance(curr_coordinate, last_coordinate)
        point_a = Geokit::LatLng.new(last_coordinate.latitude, last_coordinate.longitude)
        point_b = Geokit::LatLng.new(curr_coordinate.latitude, curr_coordinate.longitude)
        
        time = curr_coordinate.recordtime - last_coordinate.recordtime
        distance = point_a.distance_to(point_b, options = {:units=>:kms})
        
        CampaignArea.where(id: curr_coordinate.ad_id).where(area_id: curr_coordinate.area_id).update_all("time = time+" + time.to_s + "," + "distance = distance+" + distance.to_s)
    end
    
    def get_user_id_for_coordinate(coordinate)
        return Ad.find(coordinate.ad_id).user_id
    end
    
end