-- By D4KiR
local AddonName, HealerProtection = ...
local hpset = nil
function HealerProtection:ToggleSettings()
	if hpset then
		if hpset:IsShown() then
			hpset:Hide()
		else
			hpset:Show()
		end
	end
end

function HealerProtection:InitSetting()
	HPTABPC = HPTABPC or {}
	HPTABPC["MMBTNTAB"] = HPTABPC["MMBTNTAB"] or {}
	if HPTABPC["MMBTN"] == nil then
		HPTABPC["MMBTN"] = HealerProtection:GetWoWBuild() ~= "RETAIL"
	end

	HealerProtection:AddSlash("hp", HealerProtection.ToggleSettings)
	HealerProtection:AddSlash("healerprotection", HealerProtection.ToggleSettings)
	hpset = HealerProtection:CreateFrame(
		{
			["name"] = "HealerProtection Settings Frame",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = string.format("|T135923:16:16:0:0|t H|cff3FC7EBealer|rP|cff3FC7EBrotection|r by |cff3FC7EBD4KiR |T132115:16:16:0:0|t v|cff3FC7EB%s", HealerProtection:GetVersion())
		}
	)

	hpset:SetFrameLevel(110)
	hpset.SF = CreateFrame("ScrollFrame", "hpset_SF", hpset, "UIPanelScrollFrameTemplate")
	hpset.SF:SetPoint("TOPLEFT", hpset, 8, -26)
	hpset.SF:SetPoint("BOTTOMRIGHT", hpset, -32, 8)
	hpset.SC = CreateFrame("Frame", "hpset_SC", hpset.SF)
	hpset.SC:SetSize(hpset.SF:GetSize())
	hpset.SC:SetPoint("TOPLEFT", hpset.SF, "TOPLEFT", 0, 0)
	hpset.SF:SetScrollChild(hpset.SC)
	HealerProtection:SetAppendParent(hpset.SC)
	HealerProtection:SetAppendTab(HPTABPC)
	HealerProtection:SetAppendY(0)
	HealerProtection:AppendCategory("LID_general")
	HealerProtection:AppendCheckbox(
		"LID_MMBTN",
		HealerProtection:GetWoWBuild() ~= "RETAIL",
		function()
			if HPTABPC["MMBTN"] then
				HealerProtection:ShowMMBtn("HealerProtection")
			else
				HealerProtection:HideMMBtn("HealerProtection")
			end
		end
	)

	HealerProtection:AppendCategory("LID_visibility")
	HealerProtection:AppendCheckbox("LID_printnothing", false)
	HealerProtection:AppendCheckbox("LID_showasnothealer", false)
	HealerProtection:AppendCheckbox("LID_showinraids", true)
	HealerProtection:AppendCheckbox("LID_showoutsideofinstance", false)
	HealerProtection:AppendCheckbox("LID_showinbgs", false)
	HealerProtection:AppendCheckbox("LID_showtranslation", true)
	HealerProtection:AppendCheckbox("LID_showonlyenglish", false)
	HealerProtection:AppendCheckbox("LID_showonlytranslation", false)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 10)
	HealerProtection:AppendDropdown(
		"LID_channelchat",
		"AUTO",
		{
			["AUTO"] = "AUTO",
			["PARTY"] = "PARTY",
			["RAID"] = "RAID",
			["INSTANCE_CHAT"] = "INSTANCE_CHAT",
			["YELL"] = "YELL",
			["SAY"] = "SAY",
		}
	)

	HealerProtection:AppendCategory("LID_aggro")
	HealerProtection:AppendCheckbox("LID_aggro", true)
	HealerProtection:AppendCheckbox("LID_showaggrochat", true)
	HealerProtection:AppendCheckbox("LID_showaggroemote", true)
	HealerProtection:AppendSlider("LID_AGGROPercentage", 50, 20, 100, 1, 0)
	HealerProtection:AppendCategory("LID_outofmana")
	HealerProtection:AppendCheckbox("LID_outofmana", true)
	HealerProtection:AppendCheckbox("LID_showoomchat", true)
	HealerProtection:AppendCheckbox("LID_showoomemote", true)
	HealerProtection:AppendSlider("LID_OOMPercentage", 10, 1, 30, 1, 0)
	HealerProtection:AppendCategory("LID_nearoutofmana")
	HealerProtection:AppendCheckbox("LID_nearoutofmana", true)
	HealerProtection:AppendCheckbox("LID_shownearoomchat", true)
	HealerProtection:AppendCheckbox("LID_shownearoomemote", true)
	HealerProtection:AppendSlider("LID_NEAROOMPercentage", 50, 10, 50, 1, 0)
	HealerProtection:AppendCategory("LID_neardeath")
	HealerProtection:AppendCheckbox("LID_neardeath", true)
	HealerProtection:AppendCheckbox("LID_showneardeathchat", true)
	HealerProtection:AppendCheckbox("LID_showneardeathemote", true)
	HealerProtection:AppendSlider("LID_NEARDEATHPercentage", 50, 5, 40, 1, 0)
	HealerProtection:AppendCategory("LID_extras")
	HealerProtection:AppendCheckbox("LID_deathmessage", true)
	HealerProtection:AppendCheckbox("LID_notinsight", false)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 30)
	local settings_prefix = {}
	settings_prefix.name = "LID_prefix"
	settings_prefix.parent = HealerProtection:GetAppendParent()
	settings_prefix.value = HealerProtection:GetConfig("prefix", "[Healer Protection]")
	settings_prefix.text = "LID_prefix"
	settings_prefix.x = 10
	settings_prefix.y = HealerProtection:GetAppendY()
	settings_prefix.dbvalue = "prefix"
	HealerProtection:CreateTextBox(settings_prefix)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 60)
	local settings_suffix = {}
	settings_suffix.name = "LID_suffix"
	settings_suffix.parent = HealerProtection:GetAppendParent()
	settings_suffix.value = HealerProtection:GetConfig("suffix", "")
	settings_suffix.text = "LID_suffix"
	settings_suffix.x = 10
	settings_suffix.y = HealerProtection:GetAppendY()
	settings_suffix.dbvalue = "suffix"
	HealerProtection:CreateTextBox(settings_suffix)
end

local HPloaded = false
local HPSETUP = false
function HealerProtection:IsLoaded()
	return HPloaded
end

function HealerProtection:IsSetup()
	return HPSETUP
end

function HealerProtection:SetSetup(val)
	HPSETUP = val
end

local fra = CreateFrame("FRAME")
fra:RegisterEvent("PLAYER_LOGIN")
fra:RegisterEvent("ADDON_LOADED")
function fra:OnEvent(event, addonName, ...)
	if event == "ADDON_LOADED" then
		if addonName == AddonName then
			fra:UnregisterEvent("ADDON_LOADED")
			HPTABPC = HPTABPC or {}
			HPTABPC["MMBTNTAB"] = HPTABPC["MMBTNTAB"] or {}
			if HPTABPC["MMBTN"] == nil then
				HPTABPC["MMBTN"] = HealerProtection:GetWoWBuild() ~= "RETAIL"
			end

			HealerProtection:SetVersion(135923, "1.2.72")
			HealerProtection:CreateMinimapButton(
				{
					["name"] = "HealerProtection",
					["icon"] = 135923,
					["dbtab"] = HPTABPC,
					["vTT"] = {{"|T135923:16:16:0:0|t H|cff3FC7EBealer|rP|cff3FC7EBrotection|r", "v|cff3FC7EB" .. HealerProtection:GetVersion()}, {HealerProtection:Trans("LID_LEFTCLICK"), HealerProtection:Trans("LID_OPENSETTINGS")}, {HealerProtection:Trans("LID_RIGHTCLICK"), HealerProtection:Trans("LID_HIDEMINIMAPBUTTON")}},
					["funcL"] = function()
						HealerProtection:ToggleSettings()
					end,
					["funcR"] = function()
						HPTABPC["MMBTN"] = not HPTABPC["MMBTN"]
						if HPTABPC["MMBTN"] then
							HealerProtection:ShowMMBtn("HealerProtection")
						else
							HealerProtection:HideMMBtn("HealerProtection")
						end
					end,
					["dbkey"] = "MMBTN"
				}
			)
		end
	elseif event == "PLAYER_LOGIN" then
		HPloaded = true
		HPTABPC = HPTABPC or {}
		C_Timer.After(
			0,
			function()
				HealerProtection:SetSetup(true)
				HealerProtection:Setup()
			end
		)

		fra:UnregisterEvent("PLAYER_LOGIN")
	end
end

fra:SetScript("OnEvent", fra.OnEvent)
