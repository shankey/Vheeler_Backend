class EntityCampaignInfo
    attr_accessor :campaignInfoId , :areaId, :adId, :version, :schedule, :active

    def state
    	[areaId, adId, schedule]
  	end

  	def ==(o)
    	o.class == self.class && o.state == state
  	end

  	alias_method :eql?, :==

  	def hash
    	state.hash
  	end
end