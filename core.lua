-- By D4KiR
local _, HealerProtection = ...
local HPDEBUG = false
local warning_aggro = nil
local nearoom = false
local oom = false
local aggro = false
local isdead = false
local neardeath = false
local isNotHealerWarning = false
local isChanneling = false
local onceM1 = false
local onceM2 = false
local lasttarget = ""
local delayrange = GetTime()
local outsideOfGroup = false
function HealerProtection:AllowedTo()
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or HPDEBUG) and HealerProtection:DBGV("printnothing", false) == false then return true end
	if outsideOfGroup == false then
		outsideOfGroup = true
		HealerProtection:INFO("Not in a Party/Raid")
	end

	return false
end

function HealerProtection:GetCurrentChannel()
	local _channel = "PARTY"
	if HealerProtection:DBGV("channelchat", "AUTO") == "AUTO" then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			_channel = "RAID"
		elseif IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			_channel = "PARTY"
		end
	else
		_channel = HealerProtection:DBGV("channelchat", "AUTO")
	end

	return _channel
end

function HealerProtection:InInstance()
	if HPDEBUG then return true end
	local is, _ = IsInInstance()

	return is
end

function HealerProtection:CanWriteToChat(chan)
	local inInstance = HealerProtection:InInstance()
	if onceM1 and not inInstance and HealerProtection:DBGV("showoutsideofinstance", false) == false then
		onceM1 = false
		HealerProtection:MSG("Only shows Messages in Instances.")
	end

	if inInstance or HealerProtection:DBGV("showoutsideofinstance", false) then
		if HealerProtection:DBGV("printnothing", false) == true then
			if onceM2 then
				onceM2 = false
				HealerProtection:MSG("\"Print Nothing\" is enabled.")
			end

			return false
		elseif UnitInBattleground("player") ~= nil and HealerProtection:DBGV("showinbgs", false) == false then
			return false
		elseif UnitInRaid("player") ~= nil and HealerProtection:DBGV("showinraids", true) == false then
			return false
		else
			return true
		end
	end

	return false
end

function HealerProtection:GetLang()
	if GetLocale() == "enUS" then return GetLocale() end
	if HealerProtection:DBGV("showonlyenglish", false) then return "enUS" end
	if HealerProtection:DBGV("showonlytranslation", false) then return GetLocale() end
	if HealerProtection:DBGV("showtranslation", true) then return "enUS," .. GetLocale() end

	return "enUS"
end

function HealerProtection:ToCurrentChat(formatStr, val1text, val1val, val2text, val2val)
	local inInstance = HealerProtection:InInstance()
	local _channel = HealerProtection:GetCurrentChannel()
	local prefix = HealerProtection:DBGV("prefix", "[Healer Protection]")
	local suffix = HealerProtection:DBGV("suffix", "")
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

	if not inInstance and not UnitInBattleground("player") and (_channel == "YELL" or _channel == "SAY") then
		_channel = "PARTY"
	end

	if HealerProtection:CanWriteToChat(_channel) then
		local msg = ""
		if HealerProtection:GetLang() == "enUS" then
			if val2text then
				msg = string.format(formatStr, HealerProtection:TryTrans(val1text, "enUS", val1val), HealerProtection:TryTrans(val2text, "enUS", val2val))
			elseif val1text then
				msg = string.format(formatStr, HealerProtection:TryTrans(val1text, "enUS", val1val))
			end
		elseif HealerProtection:GetLang() == GetLocale() then
			if val2text then
				msg = string.format(formatStr, HealerProtection:TryTrans(val1text, GetLocale(), val1val), HealerProtection:TryTrans(val2text, GetLocale(), val2val))
			elseif val1text then
				msg = string.format(formatStr, HealerProtection:TryTrans(val1text, GetLocale(), val1val))
			end
		else
			if val2text then
				msg = string.format(formatStr, HealerProtection:TryTrans(val1text, "enUS", val1val), HealerProtection:TryTrans(val2text, "enUS", val2val))
			elseif val1text then
				msg = string.format(formatStr, HealerProtection:TryTrans(val1text, "enUS", val1val))
			end

			if val2text then
				msg = msg .. " [" .. string.format(formatStr, HealerProtection:TryTrans(val1text, GetLocale(), val1val), HealerProtection:TryTrans(val2text, GetLocale(), val2val)) .. "]"
			elseif val1text then
				msg = msg .. " [" .. string.format(formatStr, HealerProtection:TryTrans(val1text, GetLocale(), val1val)) .. "]"
			end
		end

		local mes = prefix .. msg .. "." .. suffix
		if mes ~= nil then
			if C_ChatInfo and C_ChatInfo.SendChatMessage then
				C_ChatInfo.SendChatMessage(mes, _channel)
			else
				local SendChatMessage = getglobal("SendChatMessage")
				if SendChatMessage then
					SendChatMessage(mes, _channel)
				end
			end
		end
	end
end

function HealerProtection:Setup()
	if HealerProtection:IsSetup() then
		if not InCombatLockdown() then
			HPTABPC = HPTABPC or {}
			HealerProtection:SetSetup(false)
			warning_aggro = CreateFrame("Frame", nil, UIParent)
			warning_aggro:SetFrameStrata("BACKGROUND")
			warning_aggro:SetWidth(128)
			warning_aggro:SetHeight(64)
			warning_aggro.text = warning_aggro:CreateFontString(nil, "ARTWORK")
			warning_aggro.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
			warning_aggro.text:SetPoint("CENTER", 0, 300)
			warning_aggro.text:SetText(HealerProtection:Trans("LID_youhaveaggro") .. "!")
			warning_aggro.text:SetTextColor(1, 0, 0, 1)
			warning_aggro:SetPoint("CENTER", 0, 0)
			warning_aggro:Hide()
			local function OnEvent(sel, event)
				local _, eventtype, _, _, _, _, _, _, _, _, _, _, mm, _, reason = CombatLogGetCurrentEventInfo()
				local TName = UnitName("target")
				if lasttarget ~= TName or delayrange < GetTime() then
					delayrange = GetTime() + 1
					lasttarget = TName
					local targetFriend = UnitIsFriend("player", "target")
					if eventtype == "SPELL_CAST_FAILED" and HealerProtection:IsSpellInRange(mm) and HealerProtection:DBGV("notinsight", false) and targetFriend then
						local tex = "Target is not in the field of view (" .. TName .. ")"
						if HealerProtection:DBGV("showtranslation", true) and GetLocale() ~= "enUS" then
							if HealerProtection:DBGV("showonlytranslation", false) then
								tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
							else
								tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
							end
						end

						HealerProtection:ToCurrentChat("%s", tex)
					end
				end
			end

			local f = CreateFrame("Frame")
			f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			f:SetScript("OnEvent", OnEvent)
			local channeling = CreateFrame("Frame")
			channeling:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
			channeling:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")
			channeling:SetScript(
				"OnEvent",
				function(sel, event, ...)
					if event == "UNIT_SPELLCAST_CHANNEL_START" then
						isChanneling = true
					elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
						isChanneling = false
					end
				end
			)

			HealerProtection:SetDbTab(HPTABPC)
			HealerProtection:InitSetting()
			C_Timer.NewTicker(1, HealerProtection.PrintChat)
		else
			C_Timer.After(
				0.1,
				function()
					HealerProtection:Setup()
				end
			)
		end
	end
end

function HealerProtection:PrintChat()
	local SETOOMP = getglobal("SETOOMP")
	if HealerProtection:DBGV("OOMPercentage", 10) > HealerProtection:DBGV("NEAROOMPercentage", 30) and SETOOMP ~= nil and not InCombatLockdown() then
		HPTABPC["OOMPercentage"] = HealerProtection:DBGV("NEAROOMPercentage", 30)
		SETOOMP:SetValue(HPTABPC["OOMPercentage"])
	end

	local _channel = HealerProtection:GetCurrentChannel()
	if not HealerProtection:CanWriteToChat(_channel) then return end
	if HealerProtection:IsLoaded() then
		local roleToken = "HEALER"
		if GetSpecialization and GetSpecializationRole then
			local id = GetSpecialization()
			if id ~= nil then
				roleToken = GetSpecializationRole(id)
			end
		end

		if UnitGroupRolesAssigned then
			roleToken = UnitGroupRolesAssigned("PLAYER")
		end

		if HealerProtection:GetWoWBuild() == "CLASSIC" or HealerProtection:GetWoWBuild() == "TBC" and roleToken == "NONE" then
			local GetActiveTalentGroup = getglobal("GetActiveTalentGroup")
			local GetTalentGroupRole = getglobal("GetTalentGroupRole")
			if GetActiveTalentGroup and GetTalentGroupRole then
				local group = GetActiveTalentGroup()
				local role = GetTalentGroupRole(group)
				if role and role ~= "" then
					roleToken = role
				else
					roleToken = "FAKEHEALER"
				end
			else
				roleToken = "FAKEHEALER"
			end
		end

		if roleToken == "FAKEHEALER" then
			local specId = HealerProtection:GetTalentInfo()
			local _, className = UnitClass("PLAYER")
			if className and specId then
				roleToken = HealerProtection:GetRole(className, specId)
			else
				roleToken = "HEALER"
			end
		end

		if HealerProtection:DBGV("showasnothealer", false) == false and (roleToken == "DAMAGER" or roleToken == "TANK") and not isNotHealerWarning then
			isNotHealerWarning = true
			HealerProtection:MSG("You are not a Healer.")
		end

		if (roleToken == "HEALER" or HealerProtection:DBGV("showasnothealer", false)) and not HealerProtection:DBGV("printnothing", false) then
			if not UnitIsDead("player") then
				isdead = false
				-- Aggro Logic
				if HealerProtection:DBGV("AGGRO", true) then
					local status = nil
					status = UnitThreatSituation("player")
					local hp = UnitHealth("player")
					local hpmax = UnitHealthMax("player")
					if hpmax > 0 then
						local hpperc = hp / hpmax * 100
						if status ~= nil then
							if status > 0 and not aggro and hpperc < HealerProtection:DBGV("AGGROPercentage", 50) then
								if HealerProtection:DBGV("showaggrochat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("{rt8} %s", "LID_ihaveaggro")
								end

								if HealerProtection:DBGV("showaggroemote", true) and HealerProtection:AllowedTo() and not isChanneling then
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

					if warning_aggro then
						if aggro then
							warning_aggro:Show()
						else
							warning_aggro:Hide()
						end
					end
				else
					if warning_aggro then
						warning_aggro:Hide()
					end
				end

				-- MANA Logic
				local _, powerToken, _, _, _ = UnitPowerType("player")
				if powerToken == "MANA" then
					local mana = UnitPower("player")
					local manamax = UnitPowerMax("player")
					local manaperc = HealerProtection:MathR((mana / manamax) * 100, 1)
					local health = UnitHealth("player")
					local healthmax = UnitHealthMax("player")
					local healthperc = HealerProtection:MathR(health / healthmax * 100, 1)
					-- OOM
					if HealerProtection:DBGV("OOM", true) then
						if manaperc <= HealerProtection:DBGV("OOMPercentage", 10) and not oom then
							oom = true
							if HealerProtection:DBGV("showoomchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat("(%s) %s", "LID_xmana", manaperc, "LID_outofmana")
							end

							if HealerProtection:DBGV("showoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("oom")
							end
						elseif manaperc > HealerProtection:DBGV("OOMPercentage", 10) + 20 and oom then
							oom = false
						end
					end

					-- Near OOM
					if HealerProtection:DBGV("NEAROOM", true) and not oom then
						if manaperc <= HealerProtection:DBGV("NEAROOMPercentage", 30) and not nearoom then
							nearoom = true
							if HealerProtection:DBGV("shownearoomchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat("(%s) %s", "LID_xmana", manaperc, "LID_nearoutofmana")
							end

							if HealerProtection:DBGV("shownearoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("incoming")
							end
						elseif manaperc > HealerProtection:DBGV("NEAROOMPercentage", 30) + 20 and nearoom then
							nearoom = false
						end
					end

					-- Near Death
					if HealerProtection:DBGV("NEARDEATH", true) then
						if healthperc <= HealerProtection:DBGV("NEARDEATHPercentage", 30) and not neardeath then
							neardeath = true
							local tab = {}
							tab["HEALTH"] = healthperc
							if HealerProtection:DBGV("showneardeathchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat("%s (%s)", "LID_neardeath", nil, "LID_xhealth", healthperc)
							end

							if HealerProtection:DBGV("showneardeathemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("flee")
							end
						elseif healthperc > HealerProtection:DBGV("NEAROOMPercentage", 30) + 20 and neardeath then
							neardeath = false
						end
					end
				end
			elseif not isdead then
				isdead = true
				if HealerProtection:DBGV("deathmessage", true) then
					HealerProtection:ToCurrentChat("%s", "LID_healerisdead")
				end
			end
		end
	end
end
