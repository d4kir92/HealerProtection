-- LIB Math

function HPMathR(num, dec)
	dec = dec or 2
	num = num or 0
	return tonumber(string.format("%." .. dec .. "f", num))
end

function HPRGBToDec(rgb)
	return HPMathR(rgb / 255, 2)
end
