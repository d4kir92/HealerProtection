-- Config
local _, HealerProtection = ...
function HealerProtection:GetConfig(str, val)
	HPTABPC = HPTABPC or {}
	local setting = val
	if HPTABPC ~= nil then
		if HPTABPC[str] == nil then
			HPTABPC[str] = val
		end

		setting = HPTABPC[str]
	else
		HPTABPC = HPTABPC or {}
	end

	if tonumber(setting) ~= nil then return tonumber(setting) end

	return setting
end
