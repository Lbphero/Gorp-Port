local replatablesanityfn = function(self, eater, basesanity)
    -- We pass the eater as well, since perhaps some characters gain more or less sanity from it.
    -- And perhaps we do not want to have a bonus if the basesanity is less than 0.
    return self.inst.components.replatable:GetSanityModifier(eater, basesanity)
end

local saltablesanityfn = function(self, eater, basesanity)
    return self.inst.components.saltable:GetSanityModifier(eater, basesanity)
end

AddComponentPostInit("edible", function(self, inst)
    -- In case the food is already saltable, then skip this step.
    if not inst.components.saltable and inst:HasTag("salty") then
        inst:AddComponent("saltable")
    end

    local old_GetSanity = self.GetSanity
    self.GetSanity = function(self, eater)
        local basesanity = old_GetSanity(self, eater)
        local sanitymodifier = 0

        if self.inst.components.saltable then
            sanitymodifier = sanitymodifier + saltablesanityfn(self, eater, basesanity)
        end

        if self.inst.components.replatable then
            sanitymodifier = sanitymodifier + replatablesanityfn(self, eater, basesanity)
        end

        return basesanity + sanitymodifier
    end
end)
