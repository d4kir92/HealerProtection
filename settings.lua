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
	D4:SetVersion(AddonName, 135923, "1.2.25")
	HPTABPC["MMBTNTAB"] = HPTABPC["MMBTNTAB"] or {}
	if HPTABPC["MMBTN"] == nil then
		HPTABPC["MMBTN"] = true
	end

	D4:CreateMinimapButton(
		{
			["name"] = "HealerProtection",
			["icon"] = 135923,
			["dbtab"] = HPTABPC,
			["vTT"] = {"HealerProtection", "Leftclick: Options"},
			["funcL"] = function()
				HealerProtection:ToggleSettings()
			end
		}
	)

	if HPTABPC["MMBTN"] then
		D4:GetLibDBIcon():Show("HealerProtection")
	else
		D4:GetLibDBIcon():Hide("HealerProtection")
	end

	D4:AddSlash("hp", HealerProtection.ToggleSettings)
	D4:AddSlash("healerprotection", HealerProtection.ToggleSettings)
	hpset = D4:CreateFrame(
		{
			["name"] = "HealerProtection Settings Frame",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = string.format("HealerProtection |T135923:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t v|cff3FC7EB%s", "1.2.25")
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
	D4:SetAppendParent(hpset.SC)
	D4:SetAppendTab(HPTABPC)
	D4:SetAppendY(0)
	D4:AppendCategory("general")
	D4:AppendCheckbox(
		"MMBTN",
		true,
		function()
			print(HPTABPC["MMBTN"])
			if HPTABPC["MMBTN"] then
				D4:GetLibDBIcon():Show("HealerProtection")
			else
				D4:GetLibDBIcon():Hide("HealerProtection")
			end
		end
	)

	D4:AppendCategory("visibility")
	D4:AppendCheckbox("printnothing", false)
	if UnitGroupRolesAssigned and D4:GetWoWBuildNr() > 19999 then
		D4:AppendCheckbox("showasnothealer", false)
	end

	D4:AppendCheckbox("showinraids", true)
	D4:AppendCheckbox("showoutsideofinstance", false)
	D4:AppendCheckbox("showinbgs", false)
	D4:AppendCheckbox("showtranslation", true)
	D4:AppendCheckbox("showonlyenglish", false)
	D4:AppendCheckbox("showonlytranslation", false)
	D4:SetAppendY(D4:GetAppendY() - 10)
	local settings_channel = {}
	settings_channel.name = "channelchat"
	settings_channel.parent = D4:GetAppendParent()
	settings_channel.text = "channelchat"
	settings_channel.value = HealerProtection:GetConfig("channelchat", "AUTO")
	settings_channel.x = 0
	settings_channel.y = D4:GetAppendY()
	settings_channel.dbvalue = "channelchat"
	settings_channel.tab = {}
	settings_channel.tab[0] = "AUTO"
	settings_channel.tab[1] = "PARTY"
	settings_channel.tab[2] = "RAID"
	settings_channel.tab[3] = "INSTANCE_CHAT"
	settings_channel.tab[4] = "YELL"
	settings_channel.tab[5] = "SAY"
	HealerProtection:CreateComboBox(settings_channel)
	D4:SetAppendY(D4:GetAppendY() - 30)
	D4:AppendCategory("aggro")
	D4:AppendCheckbox("aggro", true)
	D4:AppendCheckbox("showaggrochat", true)
	D4:AppendCheckbox("showaggroemote", true)
	D4:AppendSlider("AGGROPercentage", 50, 20, 100, 1, 0)
	D4:AppendCategory("outofmana")
	D4:AppendCheckbox("outofmana", true)
	D4:AppendCheckbox("showoomchat", true)
	D4:AppendCheckbox("showoomemote", true)
	D4:AppendSlider("OOMPercentage", 10, 1, 30, 1, 0)
	D4:AppendCategory("nearoutofmana")
	D4:AppendCheckbox("nearoutofmana", true)
	D4:AppendCheckbox("shownearoomchat", true)
	D4:AppendCheckbox("shownearoomemote", true)
	D4:AppendSlider("NEAROOMPercentage", 50, 10, 50, 1, 0)
	D4:AppendCategory("neardeath")
	D4:AppendCheckbox("neardeath", true)
	D4:AppendCheckbox("showneardeathchat", true)
	D4:AppendCheckbox("showneardeathemote", true)
	D4:AppendSlider("NEARDEATHPercentage", 50, 5, 40, 1, 0)
	D4:AppendCategory("extras")
	D4:AppendCheckbox("deathmessage", true)
	D4:AppendCheckbox("notinsight", false)
	D4:SetAppendY(D4:GetAppendY() - 30)
	local settings_prefix = {}
	settings_prefix.name = "prefix"
	settings_prefix.parent = D4:GetAppendParent()
	settings_prefix.value = HealerProtection:GetConfig("prefix", "[Healer Protection]")
	settings_prefix.text = "prefix"
	settings_prefix.x = 10
	settings_prefix.y = D4:GetAppendY()
	settings_prefix.dbvalue = "prefix"
	HealerProtection:CreateTextBox(settings_prefix)
	D4:SetAppendY(D4:GetAppendY() - 60)
	local settings_suffix = {}
	settings_suffix.name = "suffix"
	settings_suffix.parent = D4:GetAppendParent()
	settings_suffix.value = HealerProtection:GetConfig("suffix", "")
	settings_suffix.text = "suffix"
	settings_suffix.x = 10
	settings_suffix.y = D4:GetAppendY()
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

local vars = false
local addo = false
local frame = CreateFrame("FRAME")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("VARIABLES_LOADED")
frame:RegisterEvent("PLAYER_ENTERING_WORLD")
function frame:OnEvent(event)
	if event == "VARIABLES_LOADED" then
		vars = true
		--HealerProtection:Setup()
	end

	if event == "ADDON_LOADED" then
		addo = true
		--HealerProtection:Setup()
	end

	if vars and addo and not HealerProtection:IsLoaded() then
		HPloaded = true
		C_Timer.After(
			0,
			function()
				HealerProtection:SetSetup(true)
				HealerProtection:Setup()
			end
		)
	end
end

frame:SetScript("OnEvent", frame.OnEvent)
