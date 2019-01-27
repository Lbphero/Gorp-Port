local assets =
{
    Asset("ANIM", "anim/quagmire_safe.zip"),
    Asset("ANIM", "anim/quagmire_ui_chest_3x3.zip"),
}

local prefabs =
{
    -- "quagmire_key",
}

local function DisplayNameFn(inst)
    return inst.replica.container ~= nil
        and not inst.replica.container:CanBeOpened()
        and STRINGS.NAMES.QUAGMIRE_SAFE_LOCKED
        or nil
end

local function OnEntityReplicated(inst)
    if inst.replica.container ~= nil then
        inst.replica.container:WidgetSetup("quagmire_safe")
    end
end

local function OnUnlocked(inst, key, doer)
    if inst.components.lock ~= nil and inst.components.container ~= nil then
        inst.AnimState:PlayAnimation("unlock")
        inst.AnimState:PushAnimation("open")
        inst.AnimState:PushAnimation("opened", true)
        inst:DoTaskInTime(1, function() inst.components.container.canbeopened = true end)
        -- key:Remove()
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, .4)

    inst.MiniMapEntity:SetPriority(5)
    inst.MiniMapEntity:SetIcon("treasurechest.png")

    inst:AddTag("structure")

    inst.AnimState:SetBank("quagmire_safe")
    inst.AnimState:SetBuild("quagmire_safe")
    inst.AnimState:PlayAnimation("closed")

    MakeSnowCoveredPristine(inst)

    inst.displaynamefn = DisplayNameFn

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst.OnEntityReplicated = OnEntityReplicated

        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("quagmire_safe")
    inst.components.container.canbeopened = false

    inst:AddComponent("lock")
    inst.components.lock.locktype = "gorge_safe"
    -- inst.components.lock:SetLocked(true)
    inst.components.lock:SetOnUnlockedFn(OnUnlocked)

    -- event_server_data("quagmire", "prefabs/quagmire_safe").master_postinit(inst)

    return inst
end

local function fn2()
    local inst = fn()

    inst.AnimState:SetMultColour(0.15, 0.7, 0.95, 1)
    inst.AnimState:SetScale(1.25, 1.25, 1.25)

    if not TheWorld.ismastersim then
        return inst
    end

    inst.components.lock.locktype = "gorge_safe_2"

    return inst
end

return Prefab("gorge_safe", fn, assets, prefabs),
    Prefab("gorge_safe_2", fn2, assets, prefabs)
