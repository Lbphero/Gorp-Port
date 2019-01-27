modimport("utils/utils_common")
modimport("utils/utils_worldgen")
modimport("init/init_terrain_filters")
modimport("scripts/map/rooms/gorge_rooms")
modimport("scripts/map/tasks/gorge_tasks")

AddPreferredLayout("GorgeSafe2", "gorge_safe_2")

AddTaskSetPreInit("default", function(taskset)
    if GetModConfigBoolean("Sugarwood Biome") then
        table.insert(taskset.tasks, "Gorge saptree forest")
        table.insert(taskset.tasks, "Gorge saptree forest 2")
    end
    if GetModConfigBoolean("Salt Biome") then
        table.insert(taskset.tasks, "Gorge saltponds")
    end
    if GetModConfigBoolean("Swamp Pig Biome") then
        table.insert(taskset.tasks, "Gorge swamp")
    end

    if GetModConfigBoolean("Special Safes") then
        -- Add special safes
        taskset.set_pieces["GorgeSafe2"] =
        {
            count = 7,
            tasks = taskset.tasks,
        }
    end
end)
