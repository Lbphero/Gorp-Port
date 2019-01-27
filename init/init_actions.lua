table.insert(GLOBAL.LOCKTYPE, "gorge_safe")
table.insert(GLOBAL.LOCKTYPE, "gorge_safe_2")

AddAction(
	"TAPTREE",
	"Tap tree",
	function(act)
    	if act.target ~= nil and act.target.components.tappable ~= nil then
	        if act.target.components.tappable:IsTapped() then
	            act.target.components.tappable:UninstallTap(act.doer)
	            return true
	        elseif act.invobject ~= nil and act.invobject.components.tapper ~= nil then
	            act.target.components.tappable:InstallTap(act.doer, act.invobject)
	            return true
	        end
		end
	end
)

AddAction(
	"GIVE_DISH",
	"Put",
	function(act)
		if act.target ~= nil and act.target.components.specialstewer then
			if act.target.dish == nil and act.invobject.components.specialstewer_dish then
				if act.invobject.components.specialstewer_dish:IsDishType(act.target.components.specialstewer.cookertype) then
					act.target:SetDish(act.doer, act.invobject)
					return true
				end
			end
		end
	end
)

AddAction(
	"INSTALL",
	"Install",
	function(act)
	    if act.invobject ~= nil and act.target ~= nil then
			if act.invobject.components.installable ~= nil
				and act.target.components.installations ~= nil
                and act.target.components.installations:CanInstall(act.invobject.components.installable.prefab)
	            and act.invobject.components.installable:DoInstall(act.target) then
		            act.invobject:Remove()
		            return true
	        end
	    end
	end
)

AddAction(
	"SALT",
	"Salt",
	function(act)
		local saltable = act.target and act.target.components.saltable or nil
	    if act.invobject and saltable ~= nil then
			saltable:AddSalt()
			act.invobject.components.stackable:Get(1):Remove()
			return true
		end
	end
)

AddAction(
	"SNACKRIFICE",
	"Snackrifice",
	function(act)
		local snackrificer = act.target.components.snackrificer
		if snackrificer then
			snackrificer:Snackrifice(act.doer, act.invobject)
			return true
		end
	end
)

AddAction(
	"REPLATE",
	"Replate",
	function(act)
		local replatable = act.target and act.target.components.replatable or nil
		if act.invobject and replatable and replatable:CanReplate(act.invobject) then
			replatable:Replate(act.invobject)
			act.invobject.components.stackable:Get(1):Remove()
			return true
		end
	end
)

AddAction(
	"PLANTSOIL",
	"Plant",
	function(act)
	    if act.invobject ~= nil and
	        act.doer.components.inventory ~= nil and
	        act.target ~= nil and act.target:HasTag("soil") then
	        local seed = act.doer.components.inventory:RemoveItem(act.invobject)
	        if seed ~= nil then
	            if seed.components.gorge_plantable ~= nil and seed.components.gorge_plantable:Plant(act.target, act.doer) then
	                return true
	            end
	            act.doer.components.inventory:GiveItem(seed)
	        end
	    end
	end
)

local till = AddAction(
	"TILL",
	"Till",
	function(act)
		if act.invobject ~= nil and act.invobject.components.tiller ~= nil then
        	return act.invobject.components.tiller:Till(act.pos, act.doer)
    	end
	end
)
till.distance = 0.5
GLOBAL.TOOLACTIONS["TILL"] = true

AddComponentAction(
	"USEITEM",
	"gorge_plantable",
	function(inst, doer, target, actions)
        if target:HasTag("soil") then
			table.insert(actions, GLOBAL.ACTIONS.PLANTSOIL)
        end
    end
)

AddComponentAction(
	"POINT",
	"tiller",
	function(inst, doer, pos, actions, right)
        if right then 	-- TODO:and GLOBAL.TheWorld.Map:CanTillSoilAtPoint(pos) then
            table.insert(actions, GLOBAL.ACTIONS.TILL)
        end
    end
)

AddComponentAction(
	"SCENE",
	"tappable",
	function(inst, doer, actions, right)
		if not inst:HasTag("tappable") and not inst:HasTag("fire") then
			if right then
				table.insert(actions, GLOBAL.ACTIONS.TAPTREE) -- this is to untap the tree
			elseif inst:HasTag("tapped_harvestable") then
			 	table.insert(actions, GLOBAL.ACTIONS.HARVEST)
			end
		end
	end
)

AddComponentAction(
	"USEITEM",
	"tapper",
	function(inst, doer, target, actions)
        if target:HasTag("tappable") and not inst:HasTag("fire") and not inst:HasTag("burnt") then
            table.insert(actions, GLOBAL.ACTIONS.TAPTREE)
        end
    end
)

AddComponentAction(
	"USEITEM",
	"specialstewer_dish",
	function(inst, doer, target, actions)
        if target:HasTag("specialstewer_dishtaker") then
            table.insert(actions, GLOBAL.ACTIONS.GIVE_DISH)
        end
    end
)

AddComponentAction(
	"USEITEM",
	"salter",
	function(inst, doer, target, actions)
		if target:HasTag("saltable") then
            table.insert(actions, GLOBAL.ACTIONS.SALT)
        end
    end
)

AddComponentAction(
	"USEITEM",
	"installable",
	function(inst, doer, target, actions)
        if target:HasTag("installations") and not target:HasTag("installations_occupied") then
            table.insert(actions, GLOBAL.ACTIONS.INSTALL)
        end
    end
)

AddComponentAction(
	"USEITEM",
	"replater",
	function(inst, doer, target, actions)
		if target:HasTag("replatable") then
			table.insert(actions, GLOBAL.ACTIONS.REPLATE)
		end
	end
)

AddComponentAction(
	"USEITEM",
	"snackrificable",
	function(inst, doer, target, actions)
		if target:HasTag("gorge_altar") then
			table.insert(actions, GLOBAL.ACTIONS.SNACKRIFICE)
		end
	end
)
