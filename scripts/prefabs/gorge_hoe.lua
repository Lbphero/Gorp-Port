local assets =
{
    Asset("ANIM", "anim/quagmire_hoe.zip"),
}

local prefabs =
{
    "quagmire_soil",
}

local function onequip(inst, owner)
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
    owner.AnimState:OverrideSymbol("swap_object", "quagmire_hoe", "swap_quagmire_hoe")
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst:AddTag("sharp")

    inst.AnimState:SetBank("quagmire_hoe")
    inst.AnimState:SetBuild("quagmire_hoe")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.TILL)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "quagmire_hoe"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(10)
    inst.components.finiteuses:SetUses(10)
    inst.components.finiteuses:SetOnFinished(inst.Remove)
    inst.components.finiteuses:SetConsumption(ACTIONS.TILL, 1)

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("tiller")

    -- event_server_data("quagmire", "prefabs/quagmire_hoe").master_postinit(inst)

    return inst
end

return Prefab("gorge_hoe", fn, assets, prefabs)
