-- LIB Design

lang = lang or {}
elang = elang or {}

function HPGT(str, tab, force)
	local strid = string.lower(str)
	local result = lang[strid]
	local eng = elang[strid]

	if result ~= nil and eng ~= nil then
		if tab ~= nil then
			for i, v in pairs(tab) do
				local find = i
				local replace = v
				if find ~= nil and replace ~= nil then
					result = string.gsub(result, find, replace)
					eng = string.gsub(eng, find, replace)
				end
			end
		end
		if force then
			return result
		elseif HPGetConfig("showtranslation", true) and GetLocale() ~= "enUS" then
			if HPGetConfig( "showonlytranslation", false ) then
				return result
			else
				return eng .. " [" .. result .. "]"
			end
		else
			return eng
		end
	else
		return str
	end
end

function UpdateLanguage()

end
