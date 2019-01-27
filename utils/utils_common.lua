function GetModConfigBoolean(key)
	return GetModConfigData(key) == 1
end

function HasGorgeCropsMod()
	return GLOBAL.KnownModIndex:IsModEnabled("workshop-1422039508")
end

GLOBAL.HasGorgeCropsMod = HasGorgeCropsMod
