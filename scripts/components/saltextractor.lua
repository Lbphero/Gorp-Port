local SaltExtractor = Class(function(self, inst)
    self.inst = inst
end)

local function OnHarvest(inst, picker, produce)
    inst.extractor.AnimState:Hide("salt")
end

local function OnExtract(inst, produce)
    if produce > 0 then
        local pondcmp = inst and inst.components.saltpond or nil
        if pondcmp and pondcmp:IsDepleted() then
            -- inst:RemoveComponent("harvestable")
            inst:AddTag("depleted")
        else
            inst.extractor.AnimState:Show("salt")
            inst.extractor.AnimState:PlayAnimation("grow")
            inst.extractor.AnimState:PushAnimation("idle")
        end
    end
    -- inst.components.saltextractor.onextractfn(inst, produce)
end

function SaltExtractor:OnInstall(inst)
    print("WTF")
    local target = self.inst
    local saltpond = target.components.saltpond
    inst.entity:SetParent(target.entity)
    target.extractor = inst
    target:AddComponent("harvestable")
    target.components.harvestable:SetUp(
        saltpond.saltprefab,
        1,
        saltpond:GetExtractTime(),
        OnHarvest,
        OnExtract
    )
end

function SaltExtractor:UpdateExtractTime()
    local saltpond = self.inst.components.saltpond
    saltpond.growtime = saltpond.basetime + saltpond.timeinc * (saltpond.maxsalt - saltpond.numsalt)
end

local function OnLoad(inst, data)
    if inst:HasTag("depleted") then 
		inst.extractor.AnimState:Show("salt")
	end
end


return SaltExtractor
