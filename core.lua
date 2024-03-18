-- By D4KiR
local _, HealerProtection = ...
local HPDEBUG = false
function HealerProtection:AllowedTo()
	if (GetNumGroupMembers() > 0 or GetNumSubgroupMembers() > 0 or HPDEBUG) and HealerProtection:GetConfig("printnothing", false) == false then return true end

	return false
end

local onceM1 = false
local onceM2 = false
function HealerProtection:CanWriteToChat(chan)
	local inInstance, _ = IsInInstance()
	if onceM1 and not inInstance and HealerProtection:GetConfig("showoutsideofinstance", false) == false then
		onceM1 = false
		HealerProtection:MSG("Only shows Messages in Instances.")
	end

	if inInstance or HealerProtection:GetConfig("showoutsideofinstance", false) then
		if HealerProtection:GetConfig("printnothing", false) == true then
			if onceM2 then
				onceM2 = false
				HealerProtection:MSG("\"Print Nothing\" is enabled.")
			end

			return false
		elseif UnitInBattleground("player") ~= nil and HealerProtection:GetConfig("showinbgs", false) == false then
			return false
		elseif UnitInRaid("player") ~= nil and HealerProtection:GetConfig("showinraids", true) == false then
			return false
		else
			return true
		end
	end

	return false
end

function HealerProtection:ToCurrentChat(msg)
	local _channel = "PARTY"
	if HealerProtection:GetConfig("channelchat", "AUTO") == "AUTO" then
		if IsInRaid(LE_PARTY_CATEGORY_HOME) then
			_channel = "RAID"
		elseif IsInRaid(LE_PARTY_CATEGORY_INSTANCE) or IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup(LE_PARTY_CATEGORY_HOME) then
			_channel = "PARTY"
		end
	else
		_channel = HealerProtection:GetConfig("channelchat", "AUTO")
	end

	local prefix = HealerProtection:GetConfig("prefix", "[Healer Protection]")
	local suffix = HealerProtection:GetConfig("suffix", "")
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

	if HealerProtection:CanWriteToChat(_channel) then
		local mes = prefix .. msg .. suffix
		if mes ~= nil then
			SendChatMessage(mes, _channel)
		end
	end
end

function HealerProtection:SetupHP()
	if HealerProtection:IsSetup() then
		if not InCombatLockdown() then
			HealerProtection:SetSetup(false)
			warning_aggro = CreateFrame("Frame", nil, UIParent)
			warning_aggro:SetFrameStrata("BACKGROUND")
			warning_aggro:SetWidth(128)
			warning_aggro:SetHeight(64)
			warning_aggro.text = warning_aggro:CreateFontString(nil, "ARTWORK")
			warning_aggro.text:SetFont(STANDARD_TEXT_FONT, 20, "OUTLINE")
			warning_aggro.text:SetPoint("CENTER", 0, 300)
			warning_aggro.text:SetText(HealerProtection:GT("youhaveaggro", nil, true) .. "!")
			warning_aggro.text:SetTextColor(1, 0, 0, 1)
			hooksecurefunc(
				HealerProtection,
				"UpdateLanguage",
				function()
					warning_aggro.text:SetText(HealerProtection:GT("youhaveaggro", nil, true) .. "!")
				end
			)

			warning_aggro:SetPoint("CENTER", 0, 0)
			warning_aggro:Hide()
			HealerProtection:InitSetting()
		else
			C_Timer.After(
				0.1,
				function()
					HealerProtection:SetupHP()
				end
			)
		end
	end

	HealerProtection:LangenUS()
	if GetLocale() == "enUS" then
		--HealerProtection:MSG("Language detected: enUS (English)")
		HealerProtection:LangenUS()
	elseif GetLocale() == "deDE" then
		--HealerProtection:MSG("Language detected: deDE (Deutsch)")
		HealerProtection:LangdeDE()
	elseif GetLocale() == "esES" then
		--HealerProtection:MSG("Language detected: esES (Spanish)")
		HealerProtection:LangesES()
	elseif GetLocale() == "esMX" then
		--HealerProtection:MSG("Language detected: esMX (Spanish)")
		HealerProtection:LangesMX()
	elseif GetLocale() == "frFR" then
		--HealerProtection:MSG("Language detected: frFR (French)")
		HealerProtection:LangfrFR()
	elseif GetLocale() == "koKR" then
		--HealerProtection:MSG("Language detected: koKR (Korean)")
		HealerProtection:LangkoKR()
	elseif GetLocale() == "ruRU" then
		--HealerProtection:MSG("Language detected: ruRU (Russian)")
		HealerProtection:LangruRU()
	elseif GetLocale() == "zhCN" then
		--HealerProtection:MSG("Language detected: zhCN (Simplified Chinese)")
		HealerProtection:LangzhCN()
	elseif GetLocale() == "zhTW" then
		--HealerProtection:MSG("Language detected: zhTW (Traditional Chinese)")
		HealerProtection:LangzhTW()
	else
		HealerProtection:MSG("Language not found (" .. GetLocale() .. "), using English one!")
		HealerProtection:MSG("If you want your language, please visit the cursegaming site of this project!")
	end

	HealerProtection:UpdateLanguage()
end

local nearoom = false
local oom = false
local aggro = false
local isdead = false
local neardeath = false
local isNotHealerWarning = false
local isChanneling = false
function HealerProtection:PrintChat()
	if HealerProtection:GetConfig("OOMPercentage", 10) > HealerProtection:GetConfig("NEAROOMPercentage", 30) and SETOOMP ~= nil and not InCombatLockdown() then
		HPTABPC["OOMPercentage"] = HealerProtection:GetConfig("NEAROOMPercentage", 30)
		SETOOMP:SetValue(HPTABPC["OOMPercentage"])
	end

	if HealerProtection:IsLoaded() and warning_aggro ~= nil then
		local roleToken = "HEALER"
		if GetSpecialization and GetSpecializationRole then
			local id = GetSpecialization()
			if id ~= nil then
				roleToken = GetSpecializationRole(id)
			end
		end

		if UnitGroupRolesAssigned and D4:GetWoWBuildNr() > 19999 then
			roleToken = UnitGroupRolesAssigned("PLAYER")
		end

		if D4:GetWoWBuild() == "CLASSIC" or D4:GetWoWBuild() == "TBC" then
			roleToken = "HEALER"
		end

		if roleToken == "NONE" then
			roleToken = "HEALER"
		end

		if (roleToken == "DAMAGER" or roleToken == "TANK") and not isNotHealerWarning then
			isNotHealerWarning = true
			HealerProtection:MSG("You are not a Healer.")
		end

		if (roleToken == "HEALER" or HealerProtection:GetConfig("showasnothealer", false)) and not HealerProtection:GetConfig("printnothing", false) then
			if not UnitIsDead("player") then
				isdead = false
				-- Aggro Logic
				if HealerProtection:GetConfig("AGGRO", true) then
					local status = nil
					status = UnitThreatSituation("player")
					local hp = UnitHealth("player")
					local hpmax = UnitHealthMax("player")
					if hpmax > 0 then
						local hpperc = hp / hpmax * 100
						if status ~= nil then
							if status > 0 and not aggro and hpperc < HealerProtection:GetConfig("AGGROPercentage", 50) then
								if HealerProtection:GetConfig("showaggrochat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("{rt8}" .. " " .. HealerProtection:GT("ihaveaggro"))
								end

								if HealerProtection:GetConfig("showaggroemote", true) and HealerProtection:AllowedTo() and not isChanneling then
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
					local manaperc = HealerProtection:MathR((mana / manamax) * 100, 1)
					local health = UnitHealth("player")
					local healthmax = UnitHealthMax("player")
					local healthperc = HealerProtection:MathR(health / healthmax * 100, 1)
					-- OOM
					if HealerProtection:GetConfig("OOM", true) then
						if manaperc <= HealerProtection:GetConfig("OOMPercentage", 10) and not oom then
							oom = true
							local tab = {}
							tab["MANA"] = manaperc
							if HealerProtection:GetConfig("showoomchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat("(" .. HealerProtection:GT("xmana", tab) .. ") " .. HealerProtection:GT("outofmana") .. ".")
							end

							if HealerProtection:GetConfig("showoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("oom")
							end
						elseif manaperc > HealerProtection:GetConfig("OOMPercentage", 10) + 20 and oom then
							oom = false
						end
					end

					-- Near OOM
					if HealerProtection:GetConfig("NEAROOM", true) and not oom then
						if manaperc <= HealerProtection:GetConfig("NEAROOMPercentage", 30) and not nearoom then
							nearoom = true
							local tab = {}
							tab["MANA"] = manaperc
							if HealerProtection:GetConfig("shownearoomchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat("(" .. HealerProtection:GT("xmana", tab) .. ") " .. HealerProtection:GT("nearoutofmana") .. ".")
							end

							if HealerProtection:GetConfig("shownearoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("incoming")
							end
						elseif manaperc > HealerProtection:GetConfig("NEAROOMPercentage", 30) + 20 and nearoom then
							nearoom = false
						end
					end

					-- Near Death
					if HealerProtection:GetConfig("NEARDEATH", true) then
						if healthperc <= HealerProtection:GetConfig("NEARDEATHPercentage", 30) and not neardeath then
							neardeath = true
							local tab = {}
							tab["HEALTH"] = healthperc
							if HealerProtection:GetConfig("showneardeathchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat(HealerProtection:GT("neardeath") .. " (" .. HealerProtection:GT("xhealth", tab) .. ").")
							end

							if HealerProtection:GetConfig("showneardeathemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("flee")
							end
						elseif healthperc > HealerProtection:GetConfig("NEAROOMPercentage", 30) + 20 and neardeath then
							neardeath = false
						end
					end
				end
			elseif not isdead then
				isdead = true
				if HealerProtection:GetConfig("deathmessage", true) then
					HealerProtection:ToCurrentChat(HealerProtection:GT("healerisdead") .. ".")
				end
			end
		end
	end
end

C_Timer.NewTicker(1, HealerProtection.PrintChat)
local lasttarget = ""
local delayrange = GetTime()
local function OnEvent(self, event)
	local _, eventtype, _, _, _, _, _, _, _, _, _, _, mm, _, reason = CombatLogGetCurrentEventInfo()
	local TName = UnitName("target")
	if lasttarget ~= TName or delayrange < GetTime() then
		delayrange = GetTime() + 1
		lasttarget = TName
		if eventtype == "SPELL_CAST_FAILED" and IsSpellInRange(mm) and HealerProtection:GetConfig("notinsight", false) then
			local tex = "Target is not in the field of view (" .. TName .. ")"
			if HealerProtection:GetConfig("showtranslation", true) and GetLocale() ~= "enUS" then
				if HealerProtection:GetConfig("showonlytranslation", false) then
					tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
				else
					tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
				end
			end

			HealerProtection:ToCurrentChat(tex)
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
	function(self, event, ...)
		if event == "UNIT_SPELLCAST_CHANNEL_START" then
			isChanneling = true
		elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
			isChanneling = false
		end
	end
)