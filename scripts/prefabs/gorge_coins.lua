local assets =
{
    Asset("ANIM", "anim/quagmire_coins.zip"),
}

local prefabs =
{
    -- "quagmire_coin_fx",
}

local function MakeCoin(id)
    local function fn()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        inst.entity:AddSoundEmitter()
        inst.entity:AddNetwork()

        inst.AnimState:SetBank("quagmire_coins")
        inst.AnimState:SetBuild("quagmire_coins")
        inst.AnimState:PlayAnimation("idle")
        if id > 1 then
            inst.AnimState:OverrideSymbol("coin01", "quagmire_coins", "coin0"..tostring(id))
            inst.AnimState:OverrideSymbol("coin_shad1", "quagmire_coins", "coin_shad"..tostring(id))
        end

        inst:AddTag("coin")

        MakeInventoryPhysics(inst)

        inst.entity:SetPristine()

        if not TheWorld.ismastersim then
            return inst
        end

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = "quagmire_coin"..tostring(id)

        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")

        -- event_server_data("quagmire", "prefabs/quagmire_coins").master_postinit(inst, hasfx)

        return inst
    end

    return Prefab("coin"..id, fn, assets)
end

return MakeCoin(1),
    MakeCoin(2),
    MakeCoin(3),
    MakeCoin(4)
