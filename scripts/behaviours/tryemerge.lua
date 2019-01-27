TryEmerge = Class(BehaviourNode, function(self, inst, initialdelayfn, intervalfn, distance)
    BehaviourNode._ctor(self, "TryEmerge")
    self.inst = inst
    self.initialdelayfn = initialdelayfn
    self.intervalfn = intervalfn
    self.distance = distance
end)


function TryEmerge:Visit()
	if not self.inst.burrowed then
		self.status = FAILED
	end

    if self.status == READY then
        self.status = RUNNING
		self:Sleep(self.initialdelayfn())
    end

    if self.status == RUNNING then
		local hunter = FindEntity(self.inst, self.distance, nil, {"scarytoprey"}, {"noclick"})
		if hunter == nil then
			self.status = SUCCESS
			self.inst.sg:GoToState("emerge")
		else
			self:Sleep(self.intervalfn())
		end
    end

end
