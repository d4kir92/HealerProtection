-- Config

local AddOnName, HealerProtection = ...

SetCVar("ScriptErrors", 1)

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
	return setting
end
