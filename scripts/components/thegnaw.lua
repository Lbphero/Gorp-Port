local CRAVINGS =
{
    "snack",
    "bread",
    "soup",
    "meat",
    "fish",
    "dessert",
    "veggie",
    "cheese",
    "pasta",
}

local PICK_CRAVING_TIME = 15
local LASTMEALS_SIZE = 20
local NOVELTY_PENALTY_STEP = 0.2

local TheGnaw = Class(function(self, inst)
    self.inst = inst
    self.craving = CRAVINGS[1]
	self.task = nil
    self.satisfaction = 0
    self.lastmeals = {}
end)

function TheGnaw:RememberMeal(mealprefab)
    table.insert(self.lastmeals, mealprefab)
    if #self.lastmeals > LASTMEALS_SIZE then
        table.remove(self.lastmeals, 1)
    end
end

function TheGnaw:GetNoveltyScore(itemprefab)
    local score = 1
    for _, v in ipairs(self.lastmeals) do
        if v == itemprefab then
            score = score - NOVELTY_PENALTY_STEP
        end
    end
    return score > 0 and score or 0
end

function TheGnaw:GetCurrentCraving()
    return self.craving
end

function TheGnaw:GetMood()
	if self.satisfaction <= -3 then
		return "wrath"
	elseif self.satisfaction <= -1 then
		return "angry"
	elseif self.satisfaction <= 0 then
		return "neutral"
	else
		return "satisfied"
	end
end

function TheGnaw:PickCraving()
	self.craving = nil
	self.task = self.inst:DoTaskInTime(PICK_CRAVING_TIME, function()
		self.craving = CRAVINGS[math.random(#CRAVINGS)]
		self.task = nil
	end)
end

function TheGnaw:Punish(doer)
    local player = doer
	local n = math.min(1, math.abs(self.satisfaction) - 2)
    for i=1,n do
		local pt = Vector3(player.Transform:GetWorldPosition())
		local theta = ((i - 1) / 3) * 2 * PI
		local radius = 15
		local offset = FindWalkableOffset(pt, theta, radius, 12, true)
		if offset then
			local spawn_pt = pt + offset
			local spawn = SpawnPrefab("merm")
			spawn.components.knownlocations:RememberLocation("home", pt)
			if spawn then
				spawn.Physics:Teleport(spawn_pt:Get())
				spawn:FacePoint(pt)
				spawn.components.combat:SuggestTarget(player)
			end
		end
	end
end

function TheGnaw:ChangeSatisfaction(doer, change)
    self.satisfaction = self.satisfaction + change
    if self.satisfaction > 3 then
        self.satisfaction = 3
    end
    if self.satisfaction < -1 then
        -- TODO
        -- self.inst.SoundEmitter:PlaySound("dontstarve/quagmire/creature/gnaw/rumble", nil, .6)
        if self.satisfaction <= -3 then
			if change > 0 then
				self.satisfaction = -2
			else
				if GetPunishment() == "merm" then
					self:Punish(doer)
				end
			end
        end
		if self.satisfaction <= -5 then
			self.satisfaction = -5
		end
    end
end

return TheGnaw
