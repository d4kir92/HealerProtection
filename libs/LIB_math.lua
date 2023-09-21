-- LIB Math
local _, HealerProtection = ...
local BuildNr = select(4, GetBuildInfo())
local Build = "CLASSIC"
if BuildNr >= 100000 then
	Build = "RETAIL"
elseif BuildNr > 29999 then
	Build = "WRATH"
elseif BuildNr > 19999 then
	Build = "TBC"
end

function HealerProtection:GetWoWBuildNr()
	return BuildNr
end

function HealerProtection:GetWoWBuild()
	return Build
end

function HealerProtection:MathR(num, dec)
	dec = dec or 2
	num = num or 0

	return tonumber(string.format("%." .. dec .. "f", num))
end