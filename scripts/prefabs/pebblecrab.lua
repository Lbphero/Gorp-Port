local assets =
{
    Asset("ANIM", "anim/quagmire_pebble_crab.zip"),
}

local prefabs =
{
--     "quagmire_crabmeat",
}

local sounds =
{
    scream = "dontstarve/rabbit/scream",
    hurt = "dontstarve/rabbit/scream_short",
}

local brain = require("brains/pebblecrabbrain")

local function OnAttacked(inst, data)
    local x, y, z = inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x, y, z, 30, { "crab" }, { "INLIMBO" })
    local maxnum = 5
    for i, v in ipairs(ents) do
        v:PushEvent("gohome")
        if i >= maxnum then
            break
        end
    end
end

local function GetCookProductFn(inst, cooker, chef)
    return "crabmeat_cooked"
end

local function OnCookedFn(inst, cooker, chef)
    inst.SoundEmitter:PlaySound(sounds.hurt)
end

local function OnPickup(inst, owner)
    -- Nothing?
end

local function OnDropped(inst)
    inst.sg:GoToState("stunned")
end

local function OnInit(inst)
    inst.components.knownlocations:RememberLocation("home", Vector3(inst.Transform:GetWorldPosition()))
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 1, .25)

    inst.DynamicShadow:SetSize(1, .75)
    inst.Transform:SetSixFaced()

    inst.AnimState:SetBank("quagmire_pebble_crab")
    inst.AnimState:SetBuild("quagmire_pebble_crab")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("animal")
    inst:AddTag("prey")
    inst:AddTag("crab")
    inst:AddTag("smallcreature")
    inst:AddTag("canbetrapped")
    inst:AddTag("cattoy")
    inst:AddTag("catfood")

    MakeFeedableSmallLivestockPristine(inst)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 9
    inst:SetStateGraph("SGpebblecrab")

    inst:SetBrain(brain)

    inst:AddComponent("eater")
    inst.components.eater:SetDiet({ FOODTYPE.MEAT }, { FOODTYPE.MEAT })

    inst:AddComponent("inspectable")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.RABBIT_HEALTH * 1.5)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_pebblecrab"
    inst.components.inventoryitem.nobounce = true
    inst.components.inventoryitem.canbepickedup = false
    inst.components.inventoryitem.canbepickedupalive = true

    inst:AddComponent("cookable")
    inst.components.cookable.product = GetCookProductFn
    inst.components.cookable:SetOnCookedFn(OnCookedFn)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chest"

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"crabmeat"})

    inst:AddComponent("knownlocations")

    inst:AddComponent("sleeper")
    inst:AddComponent("tradable")

    inst.sounds = sounds

    MakeHauntablePanic(inst)

    MakeFeedableSmallLivestock(inst, TUNING.RABBIT_PERISH_TIME, OnPickup, OnDropped)

    inst:ListenForEvent("attacked", OnAttacked)

    inst:DoTaskInTime(0.1, OnInit)

    return inst
end

return Prefab("pebblecrab", fn, assets, prefabs)
