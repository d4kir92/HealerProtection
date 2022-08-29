-- Config

D4_HP = D4_HP or {}
HPname = "Healer Protection"
HPshortname = "HPTAB"
HPcolorname = "|c008888ff"
HPauthor = "D4KiR"
HPcolorauthor = "|cffffffff"

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
