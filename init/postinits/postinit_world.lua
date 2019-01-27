AddPrefabPostInit("world", function(inst)
    if GLOBAL.TheWorld.ismastersim then
        inst:AddComponent("thegnaw")
    end
end)
