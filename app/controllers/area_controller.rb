class AreaController < ApplicationController
    
    
    def area
        logger.info "inside area"
        all_area = Area.all
        area_id_to_area_map = {}
        
        all_area.each do |ar|
            if area_id_to_area_map.has_key?(ar.area_id)
                
                entity_area = area_id_to_area_map[ar.area_id]
                
                coordinate = EntityCoordinate.new
                coordinate.latitude = ar.latitude
                coordinate.longitude = ar.longitude
                entity_area.coordinates << coordinate

            else
                entity_area = EntityArea.new
                entity_area.areaId = ar.area_id
                entity_area.coordinates = Array.new
                
                coordinate = EntityCoordinate.new
                puts ar.latitude
                puts ar.longitude
                coordinate.latitude = ar.latitude
                coordinate.longitude = ar.longitude
                
                area_id_to_area_map[ar.area_id] = entity_area
                entity_area.coordinates << coordinate
            end
        end
        puts area_id_to_area_map.values.to_json 
        if(params[:pp])
            render :json => JSON.pretty_generate({:areas => JSON.parse(area_id_to_area_map.values.to_json)}),
                :status => 200
        else
                render :json => {:areas => JSON.parse(area_id_to_area_map.values.to_json)},
                :status => 200
            
            
        end
    end
end
