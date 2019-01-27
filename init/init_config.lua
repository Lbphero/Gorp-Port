local _G = GLOBAL

local function GetCurrencyPrefab()
    return GetModConfigData("Currency")
end

local function GetPunishment()
    local value = GetModConfigData("Punishment")
    if value == 1 then
        return "merm"
    end
    return nil
end

local function GetSnackrificingEnabled()
    return GetModConfigData("Snackrificing") == 1
end

_G.GetCurrencyPrefab = GetCurrencyPrefab
_G.GetPunishment = GetPunishment
_G.GetSnackrificingEnabled = GetSnackrificingEnabled
