local WALK_SPEED = 2
local RUN_SPEED = 9

require("stategraphs/commonstates")

local actionhandlers =
{
    ActionHandler(ACTIONS.EAT, "eat"),
    ActionHandler(ACTIONS.GOHOME, "action"),
}



local events=
{
    CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true,true),
    CommonHandlers.OnSleep(),
    CommonHandlers.OnFreeze(),
    EventHandler("attacked", function(inst) if not inst.components.health:IsDead() then inst.sg:GoToState("hit") end end),
--    EventHandler("death", function(inst) inst.sg:GoToState("death") end),
    EventHandler("death", function(inst, data)
				inst.sg:GoToState("death", data)
			end),
    EventHandler("trapped", function(inst) inst.sg:GoToState("trapped") end),
    -- EventHandler("locomote",
    --     function(inst)
    --         if not inst.sg:HasStateTag("idle") and not inst.sg:HasStateTag("moving") then return end
    --
    --         if not inst.components.locomotor:WantsToMoveForward() then
    --             if not inst.sg:HasStateTag("idle") then
    --                 if not inst.sg:HasStateTag("running") then
    --                     inst.sg:GoToState("idle")
    --                 end
    --                     inst.sg:GoToState("idle")
    --             end
    --         elseif inst.components.locomotor:WantsToRun() then
    --             if not inst.sg:HasStateTag("running") then
    --                 inst.sg:GoToState("run")
    --             end
    --         end
    --     end),
    EventHandler("burrow", function(inst)
        inst.sg:GoToState("burrow")
    end),
    EventHandler("emerge", function(inst)
        inst.sg:GoToState("emerge")
    end),
}

local states=
{

    -- State{
    --     name = "look",
    --     tags = {"idle", "canrotate" },
    --     onenter = function(inst)
    --         if math.random() > .5 then
    --             inst.AnimState:PlayAnimation("lookup_pre")
    --             inst.AnimState:PushAnimation("lookup_loop", true)
    --             inst.sg.statemem.lookingup = true
    --         else
    --             inst.AnimState:PlayAnimation("lookdown_pre")
    --             inst.AnimState:PushAnimation("lookdown_loop", true)
    --         end
    --         inst.sg:SetTimeout(1 + math.random())
    --     end,
    --
    --     ontimeout = function(inst)
    --         inst.sg.statemem.donelooking = true
    --         inst.AnimState:PlayAnimation(inst.sg.statemem.lookingup and "lookup_pst" or "lookdown_pst")
    --     end,
    --
    --     events =
    --     {
    --         EventHandler("animover", function (inst, data)
    --             if inst.sg.statemem.donelooking then
    --                 inst.sg:GoToState("idle")
    --             end
    --         end),
    --     },
    -- },

    State{

        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            if playanim then
                inst.AnimState:PlayAnimation(playanim)
                inst.AnimState:PushAnimation("idle", true)
            elseif not inst.AnimState:IsCurrentAnimation("idle") then
                inst.AnimState:PlayAnimation("idle", true)
            end
            -- inst.sg:SetTimeout(1 + math.random()*1)
        end,

        -- ontimeout= function(inst)
        --     inst.sg:GoToState("look")
        -- end,

    },

    State{

        name = "action",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle")
            inst:PerformBufferedAction()
        end,
        events=
        {
            EventHandler("animover", function (inst, data) inst.sg:GoToState("idle") end),
        }
    },

    State{
        name = "emerge",
        onenter = function(inst, playanim)
            inst.AnimState:SetMultColour(1, 1, 1, 1)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("emerge")
        end,
        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
                inst.burrowed = false
                -- inst.AnimState:Show()
                -- inst.AnimState:SetBuild("quagmire_pebblecrab")
                -- inst:ReturnToScene()
                inst:RemoveTag("invisible")
                inst.DynamicShadow:Enable(true)
                inst.burrowed = false
            end),
        },
    },

    State{
        name = "burrow",
        onenter = function(inst, playanim)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("burrow")
            inst.DynamicShadow:Enable(false)
        end,
        events =
        {
            EventHandler("animover", function(inst, data)
                inst.sg:GoToState("idle")
                -- inst.AnimState:Hide()
                -- inst.AnimState:SetMultColour()
                -- inst.AnimState:SetBuild("???")
                -- inst:RemoveFromScene()
                inst.AnimState:SetMultColour(0, 0, 0, 0)
                inst:AddTag("invisible")
                inst.burrowed = true
            end),
        },
    },

    State{
        name = "eat",

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle3", true)
            inst.sg:SetTimeout(2+math.random()*4)
        end,

        ontimeout= function(inst)
            inst:PerformBufferedAction()
            inst.sg:GoToState("idle")
        end,
    },

    -- State{
    --     name = "hop",
    --     tags = {"moving", "canrotate", "hopping"},
    --
    --     timeline=
    --     {
    --         TimeEvent(5*FRAMES, function(inst)
    --             inst.Physics:Stop()
    --             inst.SoundEmitter:PlaySound("dontstarve/rabbit/hop")
    --         end ),
    --     },
    --
    --     onenter = function(inst)
    --         inst.AnimState:PlayAnimation("walk")
    --         inst.components.locomotor:WalkForward()
    --         inst.sg:SetTimeout(2*math.random()+.5)
    --     end,
    --
    --     onupdate= function(inst)
    --         if not inst.components.locomotor:WantsToMoveForward() then
    --             inst.sg:GoToState("idle")
    --         end
    --     end,
    --
    --     ontimeout= function(inst)
    --         inst.sg:GoToState("hop")
    --     end,
    -- },

    State{
        name = "run",
        tags = {"moving", "running", "canrotate"},

        onenter = function(inst)
            local play_scream = true
            if inst.components.inventoryitem then
                play_scream = inst.components.inventoryitem.owner == nil
            end
            if play_scream then
                inst.SoundEmitter:PlaySound(inst.sounds.scream)
            end
            inst.AnimState:PlayAnimation("walk_pre")
            inst.AnimState:PushAnimation("walk_loop", true)
            inst.components.locomotor:RunForward()
            if not inst.burrowing then
                inst:DoTaskInTime(math.random() + 1, function()
                    inst.sg:GoToState("burrow")
                    inst.burrowing = true
                end)
            end
        end,

        --[[onupdate= function(inst)
            if not inst.components.locomotor:WantsToMoveForward() then
                inst.sg:GoToState("idle")
            end
        end, --]]

    },

    State{
        name = "death",
        tags = {"busy"},

        onenter = function(inst, data)
            inst.SoundEmitter:PlaySound(inst.sounds.scream)
            inst.AnimState:PlayAnimation("death")
            inst.Physics:Stop()
            RemovePhysicsColliders(inst)
			--print("data.afflicter",tostring(data.afflicter),type(data.afflicter))
			-- KAJ: I'm not happy with this, I'd rather set this somewhere else
			inst.causeofdeath = data and data.afflicter or nil
            inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()), data and data.afflicter or nil)
        end,

    },

     State{
        name = "fall",
        tags = {"busy", "stunned"},
        onenter = function(inst)
            inst.Physics:SetDamping(0)
            inst.Physics:SetMotorVel(0,-20+math.random()*10,0)
            inst.AnimState:PlayAnimation("idle", true)
        end,

        onupdate = function(inst)
            local pt = Point(inst.Transform:GetWorldPosition())
            if pt.y < 2 then
                inst.Physics:SetMotorVel(0,0,0)
            end

            if pt.y <= .1 then
                pt.y = 0

                inst.Physics:Stop()
                inst.Physics:SetDamping(5)
                inst.Physics:Teleport(pt.x,pt.y,pt.z)
                inst.DynamicShadow:Enable(true)
                inst.sg:GoToState("stunned")
            end
        end,

        onexit = function(inst)
            local pt = inst:GetPosition()
            pt.y = 0
            inst.Transform:SetPosition(pt:Get())
        end,
    },

    State{
        name = "stunned",
        tags = {"busy", "stunned"},

        onenter = function(inst)
            inst.Physics:Stop()
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(GetRandomWithVariance(6, 2) )
            if inst.components.inventoryitem then
                inst.components.inventoryitem.canbepickedup = true
            end
        end,

        onexit = function(inst)
            if inst.components.inventoryitem then
                inst.components.inventoryitem.canbepickedup = false
            end
        end,

        ontimeout = function(inst) inst.sg:GoToState("idle") end,
    },

    State{
        name = "trapped",
        tags = {"busy", "trapped"},

        onenter = function(inst)
            inst.Physics:Stop()
			inst:ClearBufferedAction()
            inst.AnimState:PlayAnimation("idle", true)
            inst.sg:SetTimeout(1)
        end,

        ontimeout = function(inst) inst.sg:GoToState("idle") end,
    },
    State{
        name = "hit",
        tags = {"busy"},

        onenter = function(inst)
            inst.SoundEmitter:PlaySound(inst.sounds.hurt)
            inst.AnimState:PlayAnimation("hit")
            inst.Physics:Stop()
        end,

        events=
        {
            EventHandler("animover", function(inst) inst.sg:GoToState("idle") end ),
        },
    },

}
CommonStates.AddWalkStates(states,
{
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(12*FRAMES, PlayFootstep ),
	},
},
{
	startwalk = "walk_pre",
	walk = "walk_loop",
	stopwalk = "walk_pst",
})
CommonStates.AddRunStates(states,
{
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep ),
		TimeEvent(10*FRAMES, PlayFootstep ),
	},
},
{
	startwalk = "walk_pre",
	walk = "walk_loop",
	stopwalk = "walk_pst",
})
CommonStates.AddSleepStates(states)
CommonStates.AddFrozenStates(states)


return StateGraph("pebblecrab", states, events, "idle", actionhandlers)
