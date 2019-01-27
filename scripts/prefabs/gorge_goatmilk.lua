local assets =
{
    Asset("ANIM", "anim/quagmire_goatmilk.zip"),
}

local prefabs =
{
    "quagmire_burnt_ingredients",
    "spoiled_food",
}

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("quagmire_goatmilk")
    inst.AnimState:SetBuild("quagmire_goatmilk")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)

    inst:AddTag("catfood")
    inst:AddTag("quagmire_stewable")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_goatmilk"

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("edible")
    inst.components.edible.healthvalue = 2
    inst.components.edible.hungervalue = 12.5
    inst.components.edible.sanityvalue = 0

    -- event_server_data("quagmire", "prefabs/quagmire_goatmilk").master_postinit(inst)

    return inst
end

return Prefab("gorge_goatmilk", fn, assets, prefabs)
