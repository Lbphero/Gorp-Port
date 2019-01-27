local _G = GLOBAL
local ActionHandler = _G.ActionHandler
local ACTIONS = _G.ACTIONS

AddStategraphActionHandler(
    "wilson",
    ActionHandler(ACTIONS.GIVE_DISH, "give")
)

AddStategraphActionHandler(
    "wilson",
    ActionHandler(ACTIONS.SNACKRIFICE, "give")
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(ACTIONS.GIVE_DISH, "give")
)

AddStategraphActionHandler(
    "wilson_client",
    ActionHandler(ACTIONS.SNACKRIFICE, "give")
)
