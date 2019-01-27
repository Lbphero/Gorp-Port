local assets =
{
    Asset("ANIM", "anim/merm_trader1_build.zip"),
    Asset("ANIM", "anim/merm_trader2_build.zip"),
    Asset("ANIM", "anim/quagmire_goatkid_basic.zip"),
    Asset("ANIM", "anim/ds_pig_basic.zip"),
    Asset("ANIM", "anim/ds_pig_actions.zip"),
}

local prefabs_merm =
{
    "quagmire_seedpacket_2",
    "quagmire_seedpacket_5",
    "quagmire_seedpacket_6",
    "quagmire_seedpacket_4",
    "quagmire_seedpacket_1",
    "quagmire_seedpacket_mix",
    "quagmire_key_park",
}

local prefabs_merm2 =
{
    "quagmire_seedpacket_7",
    "quagmire_seedpacket_3",
    "quagmire_sapbucket",
    "quagmire_pot_syrup",
    "quagmire_pot",
    "quagmire_casseroledish",
    "quagmire_crate_grill",
}

local function OnTurnOn(inst)
    inst.components.prototyper.on = true
end

local function OnTurnOff(inst)
    inst.components.prototyper.on = false
end

local function commonfn(common_init)
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("merm_trader1_build")

    inst.DynamicShadow:SetSize(1.5, .75)
    inst.Transform:SetFourFaced()

    inst:AddTag("character")
	inst:AddTag("prototyper")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    if common_init ~= nil then
        common_init(inst)
    end

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")


    -- event_server_data("quagmire", "prefabs/quagmire_traders").master_postinit(inst)

    return inst
end

local function mermfn()
    local inst = commonfn(function(inst)
        MakeObstaclePhysics(inst, 1)
        -- inst.Transform:SetRotation(-90)
        inst.Transform:SetRotation(0)
        inst.AnimState:PlayAnimation("idle_loop", true)
    end)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = OnTurnOn
	inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TRADING_THREE

    -- event_server_data("quagmire", "prefabs/quagmire_traders").master_postinit_merm(inst, prefabs_merm)

    return inst
end

local function merm2fn()
    local inst = commonfn(function(inst)
        MakeObstaclePhysics(inst, 1)
        inst.AnimState:SetBuild("merm_trader2_build")
        -- inst.Transform:SetRotation(-90)
        inst.Transform:SetRotation(0)
        inst.AnimState:PlayAnimation("idle_loop", true)
    end)

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = OnTurnOn
	inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TRADING_MERM2_THREE

    -- event_server_data("quagmire", "prefabs/quagmire_traders").master_postinit_merm(inst, prefabs_merm)

    return inst
end

local function goatkidfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.entity:AddNetwork()

    MakeCharacterPhysics(inst, 50, .4)

    inst.DynamicShadow:SetSize(1.5, 0.75)

    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(.8, .8, .8)

    inst.AnimState:SetBank("quagmire_goatkid_basic")
    inst.AnimState:SetBuild("quagmire_goatkid_basic")
    inst.AnimState:PlayAnimation("idle_loop", true)
    inst.AnimState:Hide("hat")

    inst:AddTag("character")
	inst:AddTag("prototyper")

    inst:AddComponent("talker")
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    inst.components.talker.offset = Vector3(0, -400, 0)
    inst.components.talker:MakeChatter()

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst:SetStateGraph("SGgoatkid")

    inst:AddComponent("prototyper")
    inst.components.prototyper.onturnon = OnTurnOn
	inst.components.prototyper.onturnoff = OnTurnOff
	inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES.TRADING_GOATKID_THREE

    inst:AddComponent("knownlocations")

    local brain = require("brains/goatkidbrain")
    inst:SetBrain(brain)

    inst:DoTaskInTime(0.1, function()
        local pos = Vector3(inst.Transform:GetWorldPosition())
        inst.components.knownlocations:RememberLocation("home", pos)
    end)

    -- event_server_data("quagmire", "prefabs/quagmire_goatkid").master_postinit(inst, prefabs)

    return inst
end

return Prefab("gorge_trader_merm", mermfn, assets, prefabs_merm),
    Prefab("gorge_trader_merm2", merm2fn, assets, prefabs_merm),
    Prefab("gorge_trader_goatkid", goatkidfn, assets, prefabs_merm)
