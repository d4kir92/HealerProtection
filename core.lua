-- By D4KiR

function HPAllowedTo()
	local _channel = HPGetConfig("channelchat", "AUTO")
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or _channel == "SAY" or _channel == "YELL") and HPGetConfig("printnothing", false) == false then
		return true
	end
	return false
end

function HPToCurrentChat(msg)
	local _channel = "SAY"
	
	if HPGetConfig("channelchat", "AUTO") == "AUTO" then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			_channel = "RAID"
		elseif IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			_channel = "PARTY"
		end
	else
		_channel = HPGetConfig("channelchat", "AUTO")
	end

	local prefix = HPGetConfig("prefix", "[Healer Protection]")
	local suffix = HPGetConfig("suffix", "")

	if prefix ~= "" and prefix ~= " " then
		prefix = prefix .. " "
	elseif prefix == " " then
		prefix = ""
	end
	if suffix ~= "" and suffix ~= " " then
		suffix = " " .. suffix
	elseif suffix == " " then
		suffix = ""
	end

	local inInstance, instanceType = IsInInstance()
	if inInstance then
		if HPGetConfig("printnothing", false) == true then
			-- print nothing
		elseif UnitInBattleground("player") ~= nil and HPGetConfig("showinbgs", false) == false then
			-- dont print in bg
		elseif UnitInRaid("player") ~= nil and HPGetConfig("showinraids", true) == false then
			-- dont print in raid
		elseif (_channel == "SAY" or _channel == "YELL") and not inInstance then
			-- ERROR: SAY and YELL only works in instance
		else
			local mes = prefix .. msg .. suffix
			if mes ~= nil then
				SendChatMessage(mes, _channel)
			end
		end
	end
end



function SetupHP()
	if HPSETUP then
		if not InCombatLockdown() then
			HPSETUP = false

			warning_aggro = CreateFrame("Frame", nil, UIParent)
			warning_aggro:SetFrameStrata("BACKGROUND")
			warning_aggro:SetWidth(128)
			warning_aggro:SetHeight(64)

			warning_aggro.text = warning_aggro:CreateFontString(nil, "ARTWORK")
			warning_aggro.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
			warning_aggro.text:SetPoint("CENTER", 0, 300)
			warning_aggro.text:SetText(HPGT("youhaveaggro", nil, true) .. "!")
			warning_aggro.text:SetTextColor(1, 0, 0, 1)

			hooksecurefunc("UpdateLanguage", function()
				warning_aggro.text:SetText(HPGT("youhaveaggro", nil, true) .. "!")
			end)

			warning_aggro:SetPoint("CENTER", 0, 0)
			warning_aggro:Hide()

			HPInitSetting()
		else
			C_Timer.After(0.1, function()	
				SetupHP()
			end)
		end
	end

	HPLang_enUS()
	if GetLocale() == "enUS" then
		--HPmsg("Language detected: enUS (English)")
		HPLang_enUS()
	elseif GetLocale() == "deDE" then
		--HPmsg("Language detected: deDE (Deutsch)")
		HPLang_deDE()
	elseif GetLocale() == "esES" then
		--HPmsg("Language detected: esES (Spanish)")
		HPLang_esES()
	elseif GetLocale() == "esMX" then
		--HPmsg("Language detected: esMX (Spanish)")
		HPLang_esMX()
	elseif GetLocale() == "frFR" then
		--HPmsg("Language detected: frFR (French)")
		HPLang_frFR()
	elseif GetLocale() == "koKR" then
		--HPmsg("Language detected: koKR (Korean)")
		HPLang_koKR()
	elseif GetLocale() == "ruRU" then
		--HPmsg("Language detected: ruRU (Russian)")
		HPLang_ruRU()
	elseif GetLocale() == "zhCN" then
		--HPmsg("Language detected: zhCN (Simplified Chinese)")
		HPLang_zhCN()
	elseif GetLocale() == "zhTW" then
		--HPmsg("Language detected: zhTW (Traditional Chinese)")
		HPLang_zhTW()
	else
		HPmsg("Language not found (" .. GetLocale() .. "), using English one!")
		HPmsg("If you want your language, please visit the cursegaming site of this project!")
	end

	UpdateLanguage()
end

local nearoom = false
local oom = false
local aggro = false
local isdead = false
local neardeath = false
function pChat()
	if HPGetConfig("OOMPercentage", 10) > HPGetConfig("NEAROOMPercentage", 30) and SETOOMP ~= nil and not InCombatLockdown() then
		HPTABPC["OOMPercentage"] = HPGetConfig("NEAROOMPercentage", 30)
		SETOOMP:SetValue(HPTABPC["OOMPercentage"])
	end

	if HPloaded and warning_aggro ~= nil then
		local roleToken = "HEALER"
		local ugra = "HEALER"
		if GetSpecialization then
			local id = GetSpecialization()
			if id ~= nil and GetSpecializationRole and UnitGroupRolesAssigned then
				roleToken = GetSpecializationRole(id)
				ugra = UnitGroupRolesAssigned("PLAYER")
			end
		end
		if UnitGroupRolesAssigned then
			roleToken = UnitGroupRolesAssigned( "PLAYER" )
		end

		if (ugra == "HEALER" or roleToken == "HEALER") and not HPGetConfig("printnothing", false) then
			if not UnitIsDead("player") then
				isdead = false

				-- Aggro Logic
				if HPGetConfig("AGGRO", true) then
					local status = nil
					status = UnitThreatSituation("player")
					local hp = UnitHealth("player")
					local hpmax = UnitHealthMax("player")
					if hpmax > 0 then
						local hpperc = hp / hpmax * 100
						if status ~= nil then
							if status > 0 and not aggro and hpperc < HPGetConfig("AGGROPercentage", 50) then
								if HPGetConfig("showaggrochat", true) and HPAllowedTo() then
									HPToCurrentChat("{rt8}" .. " " .. HPGT("ihaveaggro"))
								end
								if HPGetConfig("showaggroemote", true) and HPAllowedTo() then
									DoEmote("helpme")
								end
								aggro = true
							elseif status == 0 and aggro then
								aggro = false
							end
						else
							aggro = false
						end
					else
						aggro = false
					end

					if aggro then
						warning_aggro:Show()
					else
						warning_aggro:Hide()
					end
				else
					warning_aggro:Hide()
				end

				-- MANA Logic
				local _, powerToken, _, _, _ = UnitPowerType("player")
				if powerToken == "MANA" then
					local mana = UnitPower("player")
					local manamax = UnitPowerMax("player")
					local manaperc = HPMathR((mana / manamax) * 100, 1)

					local health = UnitHealth("player")
					local healthmax = UnitHealthMax("player")
					local healthperc = HPMathR(health / healthmax * 100, 1)

					-- OOM
					if HPGetConfig("OOM", true) then
						if manaperc <= HPGetConfig("OOMPercentage", 10) and not oom then
							oom = true
							local tab = {}
							tab["MANA"] = manaperc
							if HPGetConfig("showoomchat", true) and HPAllowedTo() then
								HPToCurrentChat(HPGT("outofmana") .. " (" .. HPGT("xmana", tab) .. ").")
							end
							if HPGetConfig("showoomemote", true) and HPAllowedTo() then
								DoEmote("oom")
							end
						elseif manaperc > HPGetConfig("OOMPercentage", 10) + 20 and oom then
							oom = false
						end
					end

					-- Near OOM
					if HPGetConfig("NEAROOM", true) and not oom then
						if manaperc <= HPGetConfig("NEAROOMPercentage", 30) and not nearoom then
							nearoom = true
							local tab = {}
							tab["MANA"] = manaperc
							if HPGetConfig("shownearoomchat", true) and HPAllowedTo() then
								HPToCurrentChat(HPGT("nearoutofmana") .. " (" .. HPGT("xmana", tab) .. ").")
							end
							if HPGetConfig("shownearoomemote", true) and HPAllowedTo() then
								DoEmote("incoming")
							end
						elseif manaperc > HPGetConfig("NEAROOMPercentage", 30) + 20 and nearoom then
							nearoom = false
						end
					end

					-- Near Death
					if HPGetConfig("NEARDEATH", true) then
						if healthperc <= HPGetConfig("NEARDEATHPercentage", 30) and not neardeath then
							neardeath = true
							local tab = {}
							tab["HEALTH"] = healthperc
							if HPGetConfig("showneardeathchat", true) and HPAllowedTo() then
								HPToCurrentChat(HPGT("neardeath") .. " (" .. HPGT("xhealth", tab) .. ").")
							end
							if HPGetConfig("showneardeathemote", true) and HPAllowedTo() then
								DoEmote("flee")
							end
						elseif healthperc > HPGetConfig("NEAROOMPercentage", 30) + 20 and neardeath then
							neardeath = false
						end
					end
				end
			elseif not isdead then
				isdead = true
				if HPGetConfig("deathmessage", true) then
					HPToCurrentChat(HPGT("healerisdead") .. ".")
				end
			end
		end
	end
end
C_Timer.NewTicker(1, pChat)

local lasttarget = ""
local delayrange = GetTime()
local function OnEvent(self, event)
	local _, eventtype, cc, dd, ee, ff, gg, hh, ii, jj, kk, ll, mm, nn, reason = CombatLogGetCurrentEventInfo()
	local TName = UnitName("target")
	if lasttarget ~= TName or delayrange < GetTime() then
		delayrange = GetTime() + 1
		lasttarget = TName
		if eventtype == "SPELL_CAST_FAILED" and IsSpellInRange(mm) then
			if HPGetConfig("notinsight", false) then
				local tex = "Target is not in the field of view (" .. TName .. ")"
				if HPGetConfig("showtranslation", true) and GetLocale() ~= "enUS" then
					if HPGetConfig( "showonlytranslation", false ) then
						tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
					else
						tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
					end
				end
				HPToCurrentChat(tex)
			end
		end
	end
end

local f = CreateFrame("Frame")
f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
f:SetScript("OnEvent", OnEvent)


