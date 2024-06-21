-- LIB Math
local _, HealerProtection = ...
HealerProtection:SetAddonOutput("HealerProtection", 135923)
function HealerProtection:MathR(num, dec)
	dec = dec or 2
	num = num or 0

	return tonumber(string.format("%." .. dec .. "f", num))
end
