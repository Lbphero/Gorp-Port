local assets_soil =
{
    Asset("ANIM", "anim/quagmire_soil.zip"),
}

local assets_seeds =
{
    Asset("ANIM", "anim/quagmire_seeds.zip"),
}

--------------------------------------------------------------------------

local PRODUCT_VALUES =
{
    ["turnip"] =
    {
        raw = {},
        cooked = {},
        leaf = 1,
        bulb = 1,
        index = 5,
    },

    ["garlic"] =
    {
        raw = {},
        cooked = {},
        leaf = 1,
        bulb = 1,
        index = 7,
    },

    ["onion"] =
    {
        raw = {},
        cooked = {},
        leaf = 1,
        bulb = 1,
        index = 4,
    },

    ["carrot"] =
    {
        raw = { prefab_override = "carrot" },
        cooked = { prefab_override = "carrot_cooked" },
        leaf = 1,
        bulb = 1,
    },

    ["potato"] =
    {
        raw = {},
        cooked = {},
        leaf = 2,
        bulb = 2,
        index = 2,
    },

    ["tomato"] =
    {
        raw = {},
        cooked = {},
        leaf = 2,
        bulb = 2,
        index = 3,
    },

    ["wheat"] =
    {
        raw = { show_spoilage = true },
        cooked = nil,
        leaf = 3,
        bulb = 3,
        index = 1,
    },
}

--------------------------------------------------------------------------

local function MakeSeed(name, id, planted_prefabs)
    local assets =
    {
        Asset("ANIM", "anim/quagmire_seeds.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("quagmire_seeds")
        inst.AnimState:SetBuild("quagmire_seeds")
        inst.AnimState:PlayAnimation("seeds_"..tostring(id))
        inst.AnimState:SetRayTestOnBB(true)

        --cookable (from cookable component) added to pristine state for optimization
        inst:AddTag("cookable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_seeds_" .. tostring(id)

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
        inst.components.perishable:StartPerishing()

        inst:AddComponent("edible")
        inst.components.edible.foodtype = FOODTYPE.SEEDS
        inst.components.edible.hungervalue = 2
        inst.components.edible.healthvalue = 0

        inst:AddComponent("plantable")
        inst.components.plantable.product = name
        inst.components.plantable.growtime = TUNING.SEEDS_GROW_TIME

        -- inst:AddComponent("gorge_plantable")
        -- inst.components.gorge_plantable:SetUp(name, growtime)

        inst:AddComponent("cookable")
        inst.components.cookable.product = "seeds_cooked"

        inst:AddComponent("bait")

        -- For compatibility with The Gorge Crops.
        if HasGorgeCropsMod() then
            inst:AddComponent("moreplantable")
        end

        -- event_server_data("quagmire", "prefabs/quagmire_plantables").master_postinit_seed(inst, id)

        return inst
    end

    return Prefab(name .. "_seeds", fn, assets_seeds, planted_prefabs)
end

--------------------------------------------------------------------------

local VARIATIONS = 3

local function SetLeafVariation(inst, leafvariation)
    for i = 1, VARIATIONS do
        if i ~= leafvariation then
            inst.AnimState:Hide("crop_leaf"..tostring(i))
        end
    end
end

local function SetBulbVariation(inst, bulbvariation)
    for i = 1, VARIATIONS do
        if i ~= bulbvariation then
            inst.AnimState:Hide("crop_bulb"..tostring(i))
        end
    end
end

--------------------------------------------------------------------------

local function OnRottenDirty(inst)
    inst:SetPrefabNameOverride(inst._rotten:value() and "quagmire_rotten_crop" or "plant_normal")
end

local function onpicked(inst)
    TheWorld:PushEvent("beginregrowth", inst)
    inst:Remove()
end

--------------------------------------------------------------------------

local function OnLeafReplicated(inst)
    local parent = inst.entity:GetParent()
    if parent ~= nil and (parent.prefab == inst.prefab:sub(1, -6).."_planted") then
        parent.highlightchildren = { inst }
    end
end

local function MakeLeaf(product, leafvariation)
    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
        Asset("ANIM", "anim/quagmire_soil.zip"),
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("grow_small")
        inst.AnimState:SetFinalOffset(3)

        SetLeafVariation(inst, leafvariation)
        SetBulbVariation(inst, nil)
        inst.AnimState:Hide("soil_back")
        inst.AnimState:Hide("soil_front")

        inst:AddTag("FX")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            inst.OnEntityReplicated = OnLeafReplicated

            return inst
        end

        inst.persists = false

        return inst
    end

    return Prefab(product.."_leaf", fn, assets)
end

------------------------------------------------

local function MakePlanted(product, bulbvariation)
    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
        Asset("ANIM", "anim/quagmire_soil.zip"),
    }

    local prefabs =
    {
        "quagmire_soil",
        "planted_soil_front",
        "planted_soil_back",
        product.."_leaf",
        product,
        "spoiled_food",
    }

    local function fn()
        local inst = CreateEntity()

        local leafvariation = PRODUCT_VALUES[product].leaf

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()


        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("crop_full", true)
        -- inst.AnimState:SetLayer(LAYER_BACKGROUND)
        -- inst.AnimState:SetSortOrder(3)
        -- inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetRayTestOnBB(true)

        SetLeafVariation(inst, leafvariation)
        SetBulbVariation(inst, bulbvariation)
        inst.AnimState:Hide("soil_back")
        inst.AnimState:Hide("soil_front")
        inst.AnimState:Hide("mouseover")
        inst.AnimState:OverrideSymbol("mouseover", "quagmire_soil", "mouseover")

        inst:AddTag("plantedsoil")
        inst:AddTag("fertilizable")

        -- inst._rotten = net_bool(inst.GUID, "quagmire_"..product.."_planted._rotten", "rottendirty")
        -- OnRottenDirty(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            -- inst:ListenForEvent("rottendirty", OnRottenDirty)

            return inst
        end

        -- local leaf = SpawnPrefab(product .. "_leaf")
        -- leaf.entity:SetParent(inst.entity)

        inst:AddComponent("inspectable")

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp(product, 10)
        inst.components.pickable.onpickedfn = onpicked
        inst.components.pickable.quickpick = product ~= "wheat" and true or false

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        -- event_server_data("quagmire", "prefabs/quagmire_plantables").master_postinit_planted(inst, product, OnRottenDirty)

        return inst
    end

    return Prefab(product.."_planted", fn, assets, prefabs)
end

local function MakePlant(product, bulbvariation)
    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
        Asset("ANIM", "anim/quagmire_soil.zip"),
    }

    local prefabs =
    {
        "quagmire_soil",
        "planted_soil_front",
        "planted_soil_back",
        product.."_leaf",
        product,
        "spoiled_food",
    }

    local function fn()
        local inst = CreateEntity()

        local leafvariation = PRODUCT_VALUES[product].leaf

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()


        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("crop_full")
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        inst.AnimState:SetFinalOffset(1)
        inst.AnimState:SetRayTestOnBB(true)

        SetLeafVariation(inst, leafvariation)
        SetBulbVariation(inst, bulbvariation)
        inst.AnimState:Hide("soil_back")
        inst.AnimState:Hide("soil_front")
        inst.AnimState:Hide("mouseover")
        inst.AnimState:OverrideSymbol("mouseover", "quagmire_soil", "mouseover")

        inst:AddTag("plantedsoil")
        inst:AddTag("fertilizable")

        -- inst._rotten = net_bool(inst.GUID, "quagmire_"..product.."_planted._rotten", "rottendirty")
        -- OnRottenDirty(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            -- inst:ListenForEvent("rottendirty", OnRottenDirty)

            return inst
        end

        -- local leaf = SpawnPrefab(product .. "_leaf")
        -- leaf.entity:SetParent(inst.entity)

        inst:AddComponent("inspectable")

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp(product, 1)
        inst.components.pickable.onpickedfn = function() inst:Remove() end
        inst.components.pickable.quickpick = false

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)

        inst:AddComponent("hauntable")
        inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

        -- event_server_data("quagmire", "prefabs/quagmire_plantables").master_postinit_planted(inst, product, OnRottenDirty)

        return inst
    end

    return Prefab(product.."_plant", fn, assets, prefabs)
end

--------------------------------------------------------------------------

local function MakeSoilFn(front)
    return function()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("quagmire_soil")
        inst.AnimState:SetBuild("quagmire_soil")
        inst.AnimState:PlayAnimation("grow_small")
        inst.AnimState:SetLayer(LAYER_BACKGROUND)
        inst.AnimState:SetSortOrder(3)
        if front then
            inst.AnimState:SetFinalOffset(2)
        end

        SetLeafVariation(inst, nil)
        SetBulbVariation(inst, nil)
        inst.AnimState:Hide("mouseover")
        inst.AnimState:Hide(front and "soil_back" or "soil_front")

        inst:AddTag("DECOR")
        inst:AddTag("NOCLICK")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst.persists = false

        return inst
    end
end

--------------------------------------------------------------------------

local function MakeRawProduct(product)
    local params = PRODUCT_VALUES[product].raw
    local cancook = PRODUCT_VALUES[product].cooked ~= nil

    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
    }

    if params.prefab_override ~= nil then
        table.insert(assets, Asset("INV_IMAGE", params.prefab_override))
    end

    local prefabs =
    {
        "spoiled_food",
    }
    if cancook then
        table.insert(prefabs, product.."_cooked")
    end

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("quagmire_crop_"..product)
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("idle")

        inst:AddTag("veggie")
        if cancook then
            --cookable (from cookable component) added to pristine state for optimization
            inst:AddTag("cookable")

            inst:AddTag("quagmire_stewable")
        end

        if params.show_spoilage then
            inst:AddTag("show_spoilage")
        end

        if params.prefab_override ~= nil then
            inst:SetPrefabNameOverride(params.prefab_override)
        end

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_" .. product

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")

        if product ~= "wheat" then
            inst:AddComponent("perishable")
            inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
            inst.components.perishable:StartPerishing()
        end

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 0
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY

        -- event_server_data("quagmire", "prefabs/quagmire_plantables").master_postinit_raw(inst, product, params.prefab_override, cancook)

        return inst
    end

    return Prefab(product, fn, assets, prefabs)
end

--------------------------------------------------------------------------

local function MakeCookedProduct(product)
    local params = PRODUCT_VALUES[product].cooked

    local assets =
    {
        Asset("ANIM", "anim/quagmire_crop_"..product..".zip"),
    }

    if params.prefab_override ~= nil then
        table.insert(assets, Asset("INV_IMAGE", params.prefab_override))
    end

    local prefabs =
    {
        "spoiled_food",
        "quagmire_burnt_ingredients",
    }

    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddNetwork()

        MakeInventoryPhysics(inst)

        inst.AnimState:SetBank("quagmire_crop_"..product)
        inst.AnimState:SetBuild("quagmire_crop_"..product)
        inst.AnimState:PlayAnimation("cooked")

        if params.prefab_override ~= nil then
            inst:SetPrefabNameOverride(params.prefab_override)
        end

        inst:AddTag("veggie")
        inst:AddTag("quagmire_stewable")

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_" .. product .. "_cooked"

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")

        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:StartPerishing()

        inst:AddComponent("edible")
        inst.components.edible.healthvalue = TUNING.HEALING_SMALL
        inst.components.edible.hungervalue = TUNING.CALORIES_TINY
        -- event_server_data("quagmire", "prefabs/quagmire_plantables").master_postinit_cooked(inst, product, params.prefab_override)

        return inst
    end

    return Prefab(product.."_cooked", fn, assets, prefabs)
end

--------------------------------------------------------------------------

local ret =
{
    Prefab("planted_soil_front", MakeSoilFn(true), assets_soil),
    Prefab("planted_soil_back", MakeSoilFn(false), assets_soil),
}

local planted_prefabs = {}
for k, v in pairs(PRODUCT_VALUES) do
    if k ~= "carrot" then
        table.insert(planted_prefabs, k.."_planted")
        table.insert(ret, MakePlanted(k, v.bulb))
        -- table.insert(ret, MakePlant(k, v.bulb))
        table.insert(ret, MakeLeaf(k, v.leaf))
        table.insert(ret, MakeRawProduct(k))
        if v.cooked ~= nil then
            table.insert(ret, MakeCookedProduct(k))
        end
    end
end
for k, v in pairs(PRODUCT_VALUES) do
    if k ~= "carrot" then
        table.insert(ret, MakeSeed(k, v.index, planted_prefabs))
    end
end
planted_prefabs = nil

return unpack(ret)
