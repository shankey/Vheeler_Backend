class EntityCampaignRun
    attr_accessor :campaignInfoId, :schedule

    def state
    	[campaignInfoId]
  	end

  	def ==(o)
    	o.class == self.class && o.state == state
  	end

  	alias_method :eql?, :==

  	def hash
    	state.hash
  	end
end