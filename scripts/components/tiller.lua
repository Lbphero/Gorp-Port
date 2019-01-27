local Tiller = Class(function(self, inst)
    self.inst = inst
    self.consumeuses = 10
end)

function Tiller:Till(pos, doer)
    local soil = SpawnPrefab("gorge_soil")
    if soil ~= nil then
        soil.Transform:SetPosition(pos:Get())
        -- doer.components.finiteuses:Use(self.consumeuses)
        return true
    end
end

return Tiller
