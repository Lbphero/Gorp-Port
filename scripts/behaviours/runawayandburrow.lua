local BURROW_DELAY = 3

RunAwayAndBurrow = Class(BehaviourNode, function(self, inst, hunterparams, see_dist, safe_dist, fn, runhome)
    BehaviourNode._ctor(self, "RunAwayAndBurrow")
    self.safe_dist = safe_dist
    self.see_dist = see_dist
    if type(hunterparams) == "string" then
        self.huntertags = { hunterparams }
        self.hunternotags = { "noclick" }
    elseif type(hunterparams) == "table" then
        self.hunterfn = hunterparams.fn
        self.huntertags = hunterparams.tags
        self.hunternotags = hunterparams.notags
        self.hunteroneoftags = hunterparams.oneoftags
    else
        self.hunterfn = hunterparams
    end
    self.inst = inst
    self.runshomewhenchased = runhome
    self.shouldrunfn = fn
    inst.burrowtask = nil
end)

function RunAwayAndBurrow:__tostring()
    return string.format("RUNAWAY %f from: %s", self.safe_dist, tostring(self.hunter))
end

function RunAwayAndBurrow:GetRunAngle(pt, hp)
    if self.avoid_angle ~= nil then
        local avoid_time = GetTime() - self.avoid_time
        if avoid_time < 1 then
            return self.avoid_angle
        else
            self.avoid_time = nil
            self.avoid_angle = nil
        end
    end

    local angle = self.inst:GetAngleToPoint(hp) + 180 -- + math.random(30)-15
    if angle > 360 then
        angle = angle - 360
    end

    --print(string.format("RunAway:GetRunAngle me: %s, hunter: %s, run: %2.2f", tostring(pt), tostring(hp), angle))

    local radius = 6

    local result_offset, result_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, 8, true, false) -- try avoiding walls
    if result_angle == nil then
        result_offset, result_angle, deflected = FindWalkableOffset(pt, angle*DEGREES, radius, 8, true, true) -- ok don't try to avoid walls, but at least avoid water
        if result_angle == nil then
            return angle -- ok whatever, just run
        end
    end

    result_angle = result_angle / DEGREES
    if deflected then
        self.avoid_time = GetTime()
        self.avoid_angle = result_angle
    end
    return result_angle
end

function RunAwayAndBurrow:Visit()
    if self.inst.burrowed then
        self.status = FAILED
    end

    if self.status == READY then
        self.hunter = FindEntity(self.inst, self.see_dist, self.hunterfn, self.huntertags, self.hunternotags, self.hunteroneoftags)

        if self.hunter ~= nil and self.shouldrunfn ~= nil and not self.shouldrunfn(self.hunter) then
            self.hunter = nil
        end

        self.status = self.hunter ~= nil and RUNNING or FAILED
        if self.hunter ~= nil and not self.inst.burrowtask then
            self.inst.burrowtask = self.inst:DoTaskInTime(BURROW_DELAY, function()
    				self.inst.components.locomotor:Stop()
    				self.inst.sg:GoToState("burrow")
    				self.inst.burrowtask = nil
    				-- self.inst.burrowed = true
    		end)
        end
    end

    if self.status == RUNNING then
		if self.inst.burrowed then
			self.status = SUCCESS
			return
		end
        if self.hunter == nil or not self.hunter.entity:IsValid() then
            self.status = FAILED
            self.inst.components.locomotor:Stop()
            -- if self.inst.burrowtask then
            --     self.inst.burrowtask = nil
            -- end
        else
            if self.runshomewhenchased and
                self.inst.components.homeseeker ~= nil then
                self.inst.components.homeseeker:GoHome(true)
            else
                local pt = self.inst:GetPosition()
                local hp = self.hunter:GetPosition()

                local angle = self:GetRunAngle(pt, hp)
                if angle ~= nil then
                    self.inst.components.locomotor:RunInDirection(angle)
                else
                    self.status = FAILED
                    self.inst.components.locomotor:Stop()
                end

                if distsq(hp, pt) > self.safe_dist * self.safe_dist then
                    self.status = SUCCESS
                    self.inst.components.locomotor:Stop()
					-- if self.inst.burrowtask ~= nil then
					-- 	self.inst.burrowtask:Cancel()
					-- end
                end
            end

            self:Sleep(.25)
        end
    end
end
