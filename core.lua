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
local isdrinkingeating = false
local onceM1 = false
local onceM2 = false
local lasttarget = ""
local delayrange = GetTime()
local outsideOfGroup = false
local maxManaPeak = 0
local lastAnnounce = {}
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
		if IsInRaid() then
			_channel = "RAID"
		elseif IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then
			_channel = "INSTANCE_CHAT"
		elseif IsInGroup() then
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
			local function IsSecret(val)
				return HealerProtection:IsSecret(val)
			end

			local function AnnounceNotInSight(reason, checkSpell)
				if not HealerProtection:DBGV("notinsight", false) then return end
				local TName = UnitName("target")
				if TName == nil or IsSecret(TName) then return end
				if lasttarget ~= TName or delayrange < GetTime() then
					delayrange = GetTime() + 1
					lasttarget = TName
					local targetFriend = UnitIsFriend("player", "target")
					if IsSecret(targetFriend) or not targetFriend then return end
					if checkSpell and not checkSpell() then return end
					local tex = "Target is not in the field of view (" .. TName .. ")"
					if reason and HealerProtection:DBGV("showtranslation", true) and GetLocale() ~= "enUS" then
						tex = tex .. " [" .. reason .. " (" .. TName .. ")]"
					end

					HealerProtection:ToCurrentChat("%s", tex)
				end
			end

			local function OnEvent(sel, event, ...)
				if event == "UI_ERROR_MESSAGE" then
					local _, message = ...
					if message == nil or IsSecret(message) or SPELL_FAILED_LINE_OF_SIGHT == nil then return end
					if message == SPELL_FAILED_LINE_OF_SIGHT then
						AnnounceNotInSight(message)
					end

					return
				end

				local _, eventtype, _, _, _, _, _, _, _, _, _, _, mm, _, reason = CombatLogGetCurrentEventInfo()
				if eventtype == "SPELL_CAST_FAILED" then
					AnnounceNotInSight(reason, function() return HealerProtection:IsSpellInRange(mm) end)
				end
			end

			local f = CreateFrame("Frame")
			if not HealerProtection:IsForever() and HealerProtection:GetWoWBuildNr() < 120000 then
				f:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
			else
				f:RegisterEvent("UI_ERROR_MESSAGE")
			end

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

			HealerProtection.manaSpellsDirty = true
			local spells = CreateFrame("Frame")
			spells:RegisterEvent("SPELLS_CHANGED")
			spells:RegisterEvent("PLAYER_ENTERING_WORLD")
			spells:SetScript(
				"OnEvent",
				function()
					HealerProtection.manaSpellsDirty = true
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

local scannerTooltip = CreateFrame("GameTooltip", "ScannerTooltip", nil, "GameTooltipTemplate")
scannerTooltip:SetOwner(WorldFrame, "ANCHOR_NONE")
local drinkWord = TUTORIAL_TITLE12 or "Drink"
local drinkRegex = "%f[%a]" .. drinkWord .. "%f[%A]"
function HealerProtection:IsUnitDrinking(unit)
	--HealerProtection:EasyFind("Trinken", true)
	unit = unit or "player"
	if C_Secrets and C_Secrets.ShouldAurasBeSecret then
		local ok, secret = pcall(C_Secrets.ShouldAurasBeSecret)
		if not ok or secret then return false end
	end

	if C_TooltipInfo and C_TooltipInfo.GetUnitAura then
		for i = 1, 32 do
			local ok, tooltipData = pcall(C_TooltipInfo.GetUnitAura, unit, i, "HELPFUL")
			if not ok or not tooltipData or HealerProtection:IsSecret(tooltipData) then break end
			for _, line in ipairs(tooltipData.lines or {}) do
				if line == nil then break end
				local text = line.leftText
				if text and not HealerProtection:IsSecret(text) and text:find(drinkRegex) then return true end
			end
		end
	else
		for i = 1, 32 do
			scannerTooltip:ClearLines()
			scannerTooltip:SetUnitAura(unit, i, "HELPFUL")
			local line = _G["ScannerTooltipTextLeft" .. 1]
			if line == nil then break end
			local text = line and line:GetText()
			if text and text:find(drinkRegex) then return true end
		end
	end

	return false
end

local function CanAnnounce(key)
	local cooldown = HealerProtection:DBGV("REPEATCOOLDOWN", 20)
	if cooldown <= 0 then return true end
	local now = GetTime()
	local last = lastAnnounce[key]
	if last ~= nil and now - last < cooldown then return false end
	lastAnnounce[key] = now

	return true
end

local function IsMaxManaDrained(manamax)
	if manamax <= 0 then return true end
	if HealerProtection:DBGV("IGNOREMAXMANADRAIN", true) == false then return false end
	if maxManaPeak > 0 and manamax < maxManaPeak * 0.5 then return true end

	return false
end

local function PublicCall(fn, ...)
	if type(fn) ~= "function" then return nil end
	local ok, value = pcall(fn, ...)
	if not ok or HealerProtection:IsSecret(value) then return nil end

	return value
end

function HealerProtection:IsSecretClient()
	return HealerProtection:IsForever() or HealerProtection:GetWoWBuildNr() >= 120000
end

function HealerProtection:PublicNumber(unit, fn)
	local value = PublicCall(fn, unit)
	if type(value) ~= "number" then return nil end

	return value
end

function HealerProtection:GetPublicHealthPercent()
	local hp = HealerProtection:PublicNumber("player", UnitHealth)
	local hpmax = HealerProtection:PublicNumber("player", UnitHealthMax)
	if hp == nil or hpmax == nil or hpmax <= 0 then return nil end

	return HealerProtection:MathR(hp / hpmax * 100, 1)
end

function HealerProtection:IsEnemyTargetingPlayer(token)
	if PublicCall(UnitExists, token) ~= true then return false end
	if PublicCall(UnitCanAttack, "player", token) ~= true then return false end

	return PublicCall(UnitIsUnit, token .. "target", "player") == true
end

function HealerProtection:IsTargetedByEnemy()
	for _, token in ipairs({"target", "focus", "mouseover", "boss1", "boss2", "boss3", "boss4", "boss5"}) do
		if HealerProtection:IsEnemyTargetingPlayer(token) then return true end
	end

	if C_NamePlate and type(C_NamePlate.GetNamePlates) == "function" then
		local ok, plates = pcall(C_NamePlate.GetNamePlates)
		if ok and type(plates) == "table" then
			for _, plate in ipairs(plates) do
				local token = plate.namePlateUnitToken or plate.unitToken or plate.UnitFrame and plate.UnitFrame.unit
				if type(token) == "string" and not HealerProtection:IsSecret(token) and HealerProtection:IsEnemyTargetingPlayer(token) then return true end
			end
		end
	end

	return false
end

function HealerProtection:GetAggroStatus()
	local ok, status = pcall(UnitThreatSituation, "player")
	if ok and not HealerProtection:IsSecret(status) then return status end
	if HealerProtection:IsTargetedByEnemy() then return 3 end

	return 0
end

function HealerProtection:GetManaCost(spellID)
	local getCost = C_Spell and C_Spell.GetSpellPowerCost or GetSpellPowerCost
	local costs = PublicCall(getCost, spellID)
	if type(costs) ~= "table" then return nil end
	local manaType = Enum and Enum.PowerType and Enum.PowerType.Mana or 0
	for _, entry in ipairs(costs) do
		local cost = entry.cost
		if entry.type == manaType and type(cost) == "number" and not HealerProtection:IsSecret(cost) and cost > 0 then return cost end
	end

	return nil
end

function HealerProtection:ForEachSpellbookSpell(callback)
	if C_SpellBook and type(C_SpellBook.GetNumSpellBookSkillLines) == "function" and Enum and Enum.SpellBookSpellBank then
		for i = 1, C_SpellBook.GetNumSpellBookSkillLines() do
			local line = C_SpellBook.GetSpellBookSkillLineInfo(i)
			if line and not line.offSpecID then
				for slot = line.itemIndexOffset + 1, line.itemIndexOffset + line.numSpellBookItems do
					local item = C_SpellBook.GetSpellBookItemInfo(slot, Enum.SpellBookSpellBank.Player)
					if item and item.itemType == Enum.SpellBookItemType.Spell and not item.isPassive and item.spellID then
						callback(item.spellID)
					end
				end
			end
		end
	elseif type(GetNumSpellTabs) == "function" then
		for i = 1, GetNumSpellTabs() do
			local _, _, offset, numSlots = GetSpellTabInfo(i)
			for slot = offset + 1, offset + numSlots do
				local spellType, spellID = GetSpellBookItemInfo(slot, "spell")
				if spellType == "SPELL" and spellID and not IsPassiveSpell(slot, "spell") then
					callback(spellID)
				end
			end
		end
	end
end

function HealerProtection:ScanManaSpells()
	local lowCost, highCost
	HealerProtection.manaSpellLow = nil
	HealerProtection.manaSpellHigh = nil
	HealerProtection:ForEachSpellbookSpell(
		function(spellID)
			local cost = HealerProtection:GetManaCost(spellID)
			if cost then
				if lowCost == nil or cost < lowCost then
					lowCost = cost
					HealerProtection.manaSpellLow = spellID
				end

				if highCost == nil or cost > highCost then
					highCost = cost
					HealerProtection.manaSpellHigh = spellID
				end
			end
		end
	)

	HealerProtection.manaSpellsDirty = false
end

function HealerProtection:IsSpellOutOfMana(spellID)
	if spellID == nil then return nil end
	local isUsable = C_Spell and C_Spell.IsSpellUsable or IsUsableSpell
	if type(isUsable) ~= "function" then return nil end
	local ok, _, noMana = pcall(isUsable, spellID)
	if not ok or HealerProtection:IsSecret(noMana) then return nil end

	return noMana == true
end

function HealerProtection:PrintChat()
	local _channel = HealerProtection:GetCurrentChannel()
	if not HealerProtection:CanWriteToChat(_channel) then return end
	if HealerProtection:IsLoaded() then
		local roleToken = HealerProtection:GetRole("player")
		if HealerProtection:DBGV("showasnothealer", false) == false and (roleToken == "DAMAGER" or roleToken == "TANK") and not isNotHealerWarning then
			isNotHealerWarning = true
			HealerProtection:MSG("You are not a Healer.")
		end

		if (roleToken == "HEALER" or HealerProtection:DBGV("showasnothealer", false)) and not HealerProtection:DBGV("printnothing", false) then
			if not UnitIsDead("player") then
				isdead = false
				-- Aggro Logic
				if HealerProtection:DBGV("AGGRO", true) then
					local status = HealerProtection:GetAggroStatus()
					local hpperc = HealerProtection:GetPublicHealthPercent()
					local healthOk = HealerProtection:IsSecretClient() or hpperc == nil or hpperc < HealerProtection:DBGV("AGGROPercentage", 50)
					if status ~= nil then
						if status > 0 and not aggro and healthOk then
							if CanAnnounce("AGGRO") then
								if HealerProtection:DBGV("showaggrochat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("{rt8} %s", "LID_ihaveaggro")
								end

								if HealerProtection:DBGV("showaggroemote", true) and HealerProtection:AllowedTo() and not isChanneling then
									DoEmote("helpme")
								end
							end

							aggro = true
						elseif status == 0 and aggro then
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
					local mana = HealerProtection:PublicNumber("player", UnitPower)
					local manamax = HealerProtection:PublicNumber("player", UnitPowerMax)
					if manamax ~= nil and (manamax > maxManaPeak or not InCombatLockdown()) then
						maxManaPeak = manamax
					end

					local manadrained = manamax ~= nil and IsMaxManaDrained(manamax)
					local manaperc = nil
					if mana ~= nil and manamax ~= nil and manamax > 0 then
						manaperc = HealerProtection:MathR((mana / manamax) * 100, 1)
					end

					local healthperc = HealerProtection:GetPublicHealthPercent()
					if manaperc == nil then
						if HealerProtection.manaSpellsDirty and not InCombatLockdown() then
							HealerProtection:ScanManaSpells()
						end

						if not InCombatLockdown() and HealerProtection:IsSpellOutOfMana(HealerProtection.manaSpellHigh) == false then
							oom = false
							nearoom = false
						end

						if HealerProtection:DBGV("OOM", true) and not oom and HealerProtection:IsSpellOutOfMana(HealerProtection.manaSpellLow) then
							oom = true
							if CanAnnounce("OOM") then
								if HealerProtection:DBGV("showoomchat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("%s", "LID_outofmana")
								end

								if HealerProtection:DBGV("showoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
									DoEmote("oom")
								end
							end
						end

						if HealerProtection:DBGV("NEAROOM", true) and not oom and not nearoom and HealerProtection:IsSpellOutOfMana(HealerProtection.manaSpellHigh) then
							nearoom = true
							if CanAnnounce("NEAROOM") then
								if HealerProtection:DBGV("shownearoomchat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("%s", "LID_nearoutofmana")
								end

								if HealerProtection:DBGV("shownearoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
									DoEmote("incoming")
								end
							end
						end
					end

					-- OOM
					if manaperc ~= nil and HealerProtection:DBGV("OOM", true) and not manadrained then
						if manaperc <= HealerProtection:DBGV("OOMPercentage", 10) and not oom then
							oom = true
							if CanAnnounce("OOM") then
								if HealerProtection:DBGV("showoomchat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("(%s) %s", "LID_xmana", manaperc, "LID_outofmana")
								end

								if HealerProtection:DBGV("showoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
									DoEmote("oom")
								end
							end
						elseif manaperc > HealerProtection:DBGV("OOMPercentage", 10) + 20 and oom then
							oom = false
						end
					end

					-- Near OOM
					if manaperc ~= nil and HealerProtection:DBGV("NEAROOM", true) and not oom and not manadrained then
						if manaperc <= HealerProtection:DBGV("NEAROOMPercentage", 30) and not nearoom then
							nearoom = true
							if CanAnnounce("NEAROOM") then
								if HealerProtection:DBGV("shownearoomchat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("(%s) %s", "LID_xmana", manaperc, "LID_nearoutofmana")
								end

								if HealerProtection:DBGV("shownearoomemote", true) and HealerProtection:AllowedTo() and not isChanneling then
									DoEmote("incoming")
								end
							end
						elseif manaperc > HealerProtection:DBGV("NEAROOMPercentage", 30) + 20 and nearoom then
							nearoom = false
						end
					end

					-- Near Death
					if healthperc ~= nil and HealerProtection:DBGV("NEARDEATH", true) then
						if healthperc <= HealerProtection:DBGV("NEARDEATHPercentage", 30) and not neardeath then
							neardeath = true
							if CanAnnounce("NEARDEATH") then
								if HealerProtection:DBGV("showneardeathchat", true) and HealerProtection:AllowedTo() then
									HealerProtection:ToCurrentChat("%s (%s)", "LID_neardeath", nil, "LID_xhealth", healthperc)
								end

								if HealerProtection:DBGV("showneardeathemote", true) and HealerProtection:AllowedTo() and not isChanneling then
									DoEmote("flee")
								end
							end
						elseif healthperc > HealerProtection:DBGV("NEARDEATHPercentage", 30) + 20 and neardeath then
							neardeath = false
						end
					end
				end

				-- Drinking / Eating Logic
				if HealerProtection:DBGV("DRINKINGEATING", true) then
					local active = HealerProtection:IsUnitDrinking()
					if active and not isdrinkingeating then
						isdrinkingeating = true
						if CanAnnounce("DRINKINGEATING") then
							if HealerProtection:DBGV("showdrinkingeatingchat", true) and HealerProtection:AllowedTo() then
								HealerProtection:ToCurrentChat("%s", "LID_drinkingeating")
							end

							if HealerProtection:DBGV("showdrinkingeatingemote", true) and HealerProtection:AllowedTo() and not isChanneling then
								DoEmote("drink")
							end
						end
					elseif not active and isdrinkingeating then
						isdrinkingeating = false
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
