local installables =
{
    "grill",
    "grill_small",
    "pot_hanger",
    "oven",
}

local function CanInstall(prefab)
    for _,v in ipairs(installables) do
        if prefab == v then
            return true
        end
    end
    return false
end

local function OnInstall(inst, target)
    inst:OnInstall(target)
end

local function OnLoad(inst, data)
    if data and data.installed and data.specialstewer then
        local obj = inst.components.installations:Install(data.installation)
        inst.components.specialstewer:OnLoad(data.specialstewer)
        if data.dish then
            local dish = GLOBAL.SpawnSaveRecord(data.dish)
            inst:SetDish(nil, dish)
        end
        if data.container then
            inst.components.container:OnLoad(data.container)
        end
    end
end

local function OnSave(inst, data)
    if inst.components.installations and inst.components.installations:IsInstalled() then
        data.installed = true
        data.installation = inst.components.installations.installation.prefab
        data.specialstewer = inst.components.specialstewer:OnSave()
        if inst.components.shelf then
            data.dish = inst.dish and inst.dish:GetSaveRecord() or nil
        end
        if inst.components.container then
            data.container = inst.components.container:OnSave()
        end
    end
end

local function OnPrefabOverrideDirty(inst)
    if inst.prefaboverride:value() ~= nil then
        inst:SetPrefabNameOverride(inst.prefaboverride:value().prefab)
        if not TheWorld.ismastersim and inst.replica.container:CanBeOpened() then
            inst.replica.container:WidgetSetup(inst.prefaboverride:value().prefab)
        end
    end
end

AddPrefabPostInit("firepit", function(inst)
    inst.Physics:SetCapsule(0.3, 2)
    -- inst.installdata = net_string(inst.GUID, "installdata", "installdatadirty")
    inst.prefaboverride = GLOBAL.net_entity(inst.GUID, "firepit.prefaboverride", "prefaboverridedirty")
    -- inst.installdata = GLOBAL.net_string(inst.GUID, "installdata", "installdatadirty")
    if not GLOBAL.TheWorld.ismastersim then
        inst:AddTag("installations")
        -- inst:ListenForEvent("installdatadirty", OnInstallClient)
        inst:ListenForEvent("refaboverridedirty", OnPrefabOverrideDirty)
        return
    end
    inst:AddComponent("installations")
    inst.components.installations:SetUp(CanInstall, OnInstall)
    inst.components.burnable:OverrideBurnFXFinalOffset(-3)
    if inst.OnLoad then
        inst.old_OnLoad = inst.OnLoad
        inst.OnLoad = function(x, data)
            inst.old_OnLoad(x, data)
            OnLoad(x, data)
        end
    else
        inst.OnLoad = OnLoad
    end
    inst.OnSave = OnSave
end)
