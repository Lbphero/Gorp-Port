local assets =
{
    Asset("ANIM", "anim/quagmire_flour.zip"),
}

local prefabs =
{
    "quagmire_burnt_ingredients",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("quagmire_flour")
    inst.AnimState:SetBuild("quagmire_flour")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("quagmire_stewable")
    inst:AddTag("flour")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_flour"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    -- event_server_data("quagmire", "prefabs/quagmire_flour").master_postinit(inst)

    return inst
end

return Prefab("flour", fn, assets, prefabs)
