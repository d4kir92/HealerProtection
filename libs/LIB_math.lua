-- LIB Math
local _, HealerProtection = ...
function HealerProtection:MathR(num, dec)
	dec = dec or 2
	num = num or 0

	return tonumber(string.format("%." .. dec .. "f", num))
end