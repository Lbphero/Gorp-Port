local assets =
{
    Asset("ANIM", "anim/quagmire_seedpacket.zip"),
}

local plantables = {
    "turnip",
    "garlic",
    "onion",
    "carrot",
    "potato",
    "tomato",
    "wheat",
}

local function displaynamefn(inst)
    -- TODO
    return "Seedpacket"
    -- return STRINGS.NAMES[string.upper("seedpacket_"..(inst._id:value() > 0 and tostring(inst._id:value()) or "mix"))]
end

local function GetSeedData(name)
    local inst = SpawnPrefab(name .. "_seeds")
    local data = inst:GetSaveRecord()
    inst:Remove()
    return data
end

local function PickRandomPlant()
    local prefab = plantables[math.random(#plantables)]
    return prefab
end

local function GetItemData(id)
    local data = {}
    if id == nil then
        data = {}
    elseif id == "mix" then
        for i = 1, 3, 1 do
            table.insert(data, GetSeedData(PickRandomPlant()))
        end
    else
        for i = 1, 3, 1 do
            table.insert(data, GetSeedData(plantables[id]))
        end
    end
    return data
end

local function OnUnwrapped(inst, pos, doer)
    inst:Remove()
end

local function MakeSeedPacket(id)
    local prefabs
    local name = "seedpacket"..(id ~= nil and ("_"..tostring(id)) or "")
    local realname
    if id == "mix" then
        realname = "seedpacket_mix"
    else
        realname = "seedpacket"..(id ~= nil and ("_"..plantables[id]) or "")
    end
    if id == nil then
        prefabs =
        {
            "ash",
            "seedpacket_unwrap",
        }
    elseif id == "mix" then
        prefabs = { "seedpacket" }
        for i = 1, QUAGMIRE_NUM_SEEDS_PREFABS do
            table.insert(prefabs, "quagmire_seeds_"..tostring(i))
        end
    else
        prefabs =
        {
            "quagmire_seedpacket",
            "quagmire_seeds_"..tostring(id)
        }
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("quagmire_seedpacket")
        inst.AnimState:SetBuild("quagmire_seedpacket")
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("bundle")

        --unwrappable (from unwrappable component) added to pristine state for optimization
        inst:AddTag("unwrappable")

        -- inst._id = net_tinybyte(inst.GUID, "quagmire_seedpacket._id", "iddirty")
        inst.displaynamefn = displaynamefn
        if id ~= nil then
            inst:SetPrefabName("quagmire_seedpacket")
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_" .. name

        inst:AddComponent("unwrappable")
        inst.components.unwrappable.itemdata = GetItemData(id)
        inst.components.unwrappable:SetOnUnwrappedFn(OnUnwrapped)

        -- event_server_data("quagmire", "prefabs/quagmire_seedpackets").master_postinit(inst, id)

        return inst
    end

    return Prefab(realname, fn, assets, prefabs)
end

local ret =
{
    MakeSeedPacket(),
    MakeSeedPacket("mix"),
}
for i = 1, QUAGMIRE_NUM_SEEDS_PREFABS do
    table.insert(ret, MakeSeedPacket(i))
end
return unpack(ret)
