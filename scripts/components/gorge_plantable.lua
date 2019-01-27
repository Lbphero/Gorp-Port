local GorgePlantable = Class(function(self, inst)
    self.inst = inst
    self.growtime = 120
    self.product = nil
end)

function GorgePlantable:SetUp(product, growtime)
    self.product = product
    self.growtime = growtime
end

function GorgePlantable:Plant(target, doer)
    local plant = SpawnPrefab(product .. "_planted")
    if plant ~= nil then
        plant.Transform:SetPosition(target.Transform:GetWorldPosition())
        target:Remove()
    end
end

return GorgePlantable
