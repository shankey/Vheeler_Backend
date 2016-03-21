class EntityGmapCoordinate
    attr_accessor :id,:lat, :lng
    
    def to_s
        return id.to_s+","+lat.to_s+","+lng.to_s
    end
end