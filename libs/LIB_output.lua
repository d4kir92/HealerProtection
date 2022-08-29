-- LIB Output

D4_HP = D4_HP or {}

function HPmsg(str)
	print("|c0000ffff" .. "[" .. "|cff8888ff" .. HPname .. "|c0000ffff" .. "] " .. str)
end

function HPdeb(str)
	if HPDEBUG then
		print("[DEB] " .. str)
	end
end

function HPpTab(tab)
	print("HPpTab", tab)
	for i, v in pairs(tab) do
		if type(v) == "table" then
			HPpTab(v)
		else
			print(i, v)
		end
	end
	print("----------------------------------")
end
