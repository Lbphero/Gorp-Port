local assets =
{
    Asset("ANIM", "anim/quagmire_mushrooms.zip"),
    Asset("ANIM", "anim/quagmire_mushroomstump.zip"),
}

local prefabs =
{
    -- "quagmire_mushrooms_cooked",
}

local prefabs_cooked =
{
    -- "quagmire_burnt_ingredients",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_mushrooms")
    inst.AnimState:SetBuild("quagmire_mushrooms")
    inst.AnimState:PlayAnimation("raw")

    --cookable (from cookable component) added to pristine state for optimization
    inst:AddTag("cookable")

    inst:AddTag("quagmire_stewable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "gorge_mushrooms_cooked"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
    inst.components.perishable:StartPerishing()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_mushrooms"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.hungervalue = 3
    inst.components.edible.healthvalue = -5
    inst.components.edible.sanityvalue = -20

    inst:AddComponent("tradable")

    inst:AddComponent("bait")

    -- event_server_data("quagmire", "prefabs/quagmire_mushrooms").master_postinit(inst)

    return inst
end

local function cookedfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_mushrooms")
    inst.AnimState:SetBuild("quagmire_mushrooms")
    inst.AnimState:PlayAnimation("cooked")

    inst:AddTag("quagmire_stewable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("cookable")
    inst.components.cookable.product = "gorge_mushrooms_cooked"

    inst:AddComponent("perishable")
    inst.components.perishable:SetPerishTime(TUNING.PERISH_SLOW)
    inst.components.perishable:StartPerishing()

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_mushrooms_cooked"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.foodtype = FOODTYPE.VEGGIE
    inst.components.edible.hungervalue = 3
    inst.components.edible.healthvalue = 2
    inst.components.edible.sanityvalue = -3

    inst:AddComponent("tradable")

    inst:AddComponent("bait")
    -- event_server_data("quagmire", "prefabs/quagmire_mushrooms").master_postinit_cooked(inst)

    return inst
end

local GROW_TIME = 500 + math.random() * 100

local function MakePickable(inst)
    inst.AnimState:ShowSymbol("a1")
    inst.AnimState:ShowSymbol("a2")
    inst.AnimState:ShowSymbol("a3")
    inst.AnimState:ShowSymbol("a4")
    inst.AnimState:ShowSymbol("a5")
    inst.components.pickable.canbepicked = true
end

local function OnPicked(inst)
    inst.AnimState:PlayAnimation("pick")
    inst.AnimState:PushAnimation("idle", true)
    inst.AnimState:HideSymbol("a1")
    inst.AnimState:HideSymbol("a2")
    inst.AnimState:HideSymbol("a3")
    inst.AnimState:HideSymbol("a4")
    inst.AnimState:HideSymbol("a5")
    inst.components.pickable.canbepicked = false
    inst:DoTaskInTime(GROW_TIME, MakePickable)
end

local function stumpfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.Transform:SetScale(0.7, 0.7, 0.7)

    MakeSmallObstaclePhysics(inst, .2)
    inst:SetPhysicsRadiusOverride(1.0)

    inst.MiniMapEntity:SetIcon("quagmire_mushroomstump.png")

    inst.AnimState:SetBank("quagmire_mushroomstump")
    inst.AnimState:SetBuild("quagmire_mushroomstump")
    inst.AnimState:PlayAnimation("idle", true)

    -- for stats tracking
    -- inst:AddTag("quagmire_wildplant")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("pickable")
    inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
    inst.components.pickable:SetUp("gorge_mushrooms", 10)
    inst.components.pickable.onpickedfn = OnPicked
    inst.components.pickable.quickpick = false

    event_server_data("quagmire", "prefabs/quagmire_mushroomstump").master_postinit(inst)

    return inst
end

return Prefab("gorge_mushrooms", fn, assets, prefabs),
    Prefab("gorge_mushrooms_cooked", cookedfn, assets, prefabs_cooked),
    Prefab("gorge_mushrooms_stump", stumpfn, assets, prefabs)
