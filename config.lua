-- Config

D4_HP = D4_HP or {}
HPname = "HealerProtection |T135923/:16:16:0:0|t by |cff3FC7EBD4KiR |T132115/:16:16:0:0|t"

SetCVar("ScriptErrors", 1)
HPDEBUG = false

HPTABPC = HPTABPC or {}

function HPGetConfig(str, val)
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
