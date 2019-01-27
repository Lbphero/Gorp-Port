AddComponentPostInit("saltable", function(self, inst)
    local old_GetAdjectivedName = inst.GetAdjectivedName
    inst.GetAdjectivedName = function(inst)
        local name = old_GetAdjectivedName(inst)
        if inst:HasTag("salted") then
            name = "Salted " .. name
        end
        return name
    end
end)
