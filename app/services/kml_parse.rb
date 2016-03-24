class KmlParse

    def parse
        xml_doc  = Nokogiri::XML(File.open("public/testcoo.kml"))
        name_node = nil
        xml_doc.css("name").each do |name|
            content = name.text
            puts content
            if(content == "Sample Coordinates")
                name_node = name
                break
            end
        end
        puts name_node.text
        folder_node = name_node.parent
        
        k = Random.new
        t=Time.now
        folder_node.css("Placemark").each do |placemark|
            name = placemark.css("name").text
            coordinates = placemark.css("coordinates").text
            
            coos = coordinates.split(" ")
            
            
            area_id = k.rand(1..6)
            ad_id = area_id
            coos.each do |c|
                
                latlng = c.split(",")
                lng = latlng[0]
                lat = latlng[1]
                db_coo = Coordinate.new
                db_coo.latitude = lat
                db_coo.longitude = lng
                db_coo.area_id = area_id
                db_coo.ad_id = ad_id
                
                t = t + k.rand(10..122)
                db_coo.recordtime = t
                db_coo.device_id = name
                db_coo.save
                puts db_coo
            end
        end
    end

end