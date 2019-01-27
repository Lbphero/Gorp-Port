require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"
require "behaviours/leash"
require "behaviours/runawayandburrow"
require "behaviours/tryemerge"

local MAX_WANDER_DIST = 20
local LEASH_RETURN_DIST = 5
local LEASH_MAX_DIST = 20
local WAIT_PERIOD = 10
local STOP_RUN_DIST = 10
local SEE_PLAYER_DIST = 5
local AVOID_PLAYER_DIST = 6
local AVOID_PLAYER_STOP = 9
local SEE_BAIT_DIST = 10
local EMERGE_DELAY_INITIAL = 15
local EMERGE_DELAY_INTERVAL = 5
local EMERGE_SAFE_DISTANCE = 7

local function GetHomePos(inst)
    return inst.components.knownlocations:GetLocation("home") or nil
end

local PebbleCrabBrain = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function PebbleCrabBrain:OnStart()
	local aboveground = WhileNode(function() return not self.inst.burrowed end, "Above ground",
		PriorityNode{
			WhileNode( function() return self.inst.components.hauntable and self.inst.components.hauntable.panic end, "PanicHaunted", Panic(self.inst)),
			WhileNode( function() return self.inst.components.health.takingfiredamage end, "OnFire", Panic(self.inst)),
			RunAwayAndBurrow(self.inst, "scarytoprey", AVOID_PLAYER_DIST, AVOID_PLAYER_STOP),
	--         RunAway(self.inst, "scarytoprey", SEE_PLAYER_DIST, STOP_RUN_DIST, nil, true),
			--Leash(self.inst, GetHomePos, LEASH_MAX_DIST, LEASH_RETURN_DIST),
			Wander(self.inst, GetHomePos, MAX_WANDER_DIST),
	}, 1)

	local burrowed = WhileNode(function() return self.inst.burrowed end, "Burrowed",
		PriorityNode{
			TryEmerge(
				self.inst,
				function() return math.random() * EMERGE_DELAY_INITIAL end,
				function() return math.random() * EMERGE_DELAY_INTERVAL end,
				EMERGE_SAFE_DISTANCE
			),
	}, 1)

	local root = PriorityNode({
			aboveground,
			burrowed,
	}, 0.5)

	self.bt = BT(self.inst, root)
end

return PebbleCrabBrain
