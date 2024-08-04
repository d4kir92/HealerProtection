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
	HealerProtection:SetVersion(AddonName, 135923, "1.2.33")
	HPTABPC["MMBTNTAB"] = HPTABPC["MMBTNTAB"] or {}
	C_Timer.After(
		0,
		function()
			if HPTABPC["MMBTN"] == nil then
				HPTABPC["MMBTN"] = HealerProtection:GetWoWBuild() ~= "RETAIL"
			end

			HealerProtection:CreateMinimapButton(
				{
					["name"] = "HealerProtection",
					["icon"] = 135923,
					["dbtab"] = HPTABPC,
					["vTT"] = {{"HealerProtection |T135923:16:16:0:0|t", "v|cff3FC7EB1.2.33"}, {"Leftclick", "Options"}, {"Rightclick", "Toggle Minimapbutton"}},
					["funcL"] = function()
						HealerProtection:ToggleSettings()
					end,
					["funcR"] = function()
						HPTABPC["MMBTN"] = not HPTABPC["MMBTN"]
						if HPTABPC["MMBTN"] then
							HealerProtection:GetLibDBIcon():Show("HealerProtection")
						else
							HealerProtection:GetLibDBIcon():Hide("HealerProtection")
						end
					end
				}
			)

			if HPTABPC["MMBTN"] then
				HealerProtection:GetLibDBIcon():Show("HealerProtection")
			else
				HealerProtection:GetLibDBIcon():Hide("HealerProtection")
			end
		end
	)

	HealerProtection:AddSlash("hp", HealerProtection.ToggleSettings)
	HealerProtection:AddSlash("healerprotection", HealerProtection.ToggleSettings)
	hpset = HealerProtection:CreateFrame(
		{
			["name"] = "HealerProtection Settings Frame",
			["pTab"] = {"CENTER"},
			["sw"] = 520,
			["sh"] = 520,
			["title"] = string.format("HealerProtection |T135923:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t v|cff3FC7EB%s", "1.2.33")
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
	HealerProtection:AppendCategory("general")
	HealerProtection:AppendCheckbox(
		"MMBTN",
		HealerProtection:GetWoWBuild() ~= "RETAIL",
		function()
			if HPTABPC["MMBTN"] then
				HealerProtection:ShowMMBtn("HealerProtection")
			else
				HealerProtection:HideMMBtn("HealerProtection")
			end
		end
	)

	HealerProtection:AppendCategory("visibility")
	HealerProtection:AppendCheckbox("printnothing", false)
	if UnitGroupRolesAssigned and HealerProtection:GetWoWBuildNr() > 19999 then
		HealerProtection:AppendCheckbox("showasnothealer", false)
	end

	HealerProtection:AppendCheckbox("showinraids", true)
	HealerProtection:AppendCheckbox("showoutsideofinstance", false)
	HealerProtection:AppendCheckbox("showinbgs", false)
	HealerProtection:AppendCheckbox("showtranslation", true)
	HealerProtection:AppendCheckbox("showonlyenglish", false)
	HealerProtection:AppendCheckbox("showonlytranslation", false)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 10)
	local settings_channel = {}
	settings_channel.name = "channelchat"
	settings_channel.parent = HealerProtection:GetAppendParent()
	settings_channel.text = "channelchat"
	settings_channel.value = HealerProtection:GetConfig("channelchat", "AUTO")
	settings_channel.x = 0
	settings_channel.y = HealerProtection:GetAppendY()
	settings_channel.dbvalue = "channelchat"
	settings_channel.tab = {}
	settings_channel.tab[0] = "AUTO"
	settings_channel.tab[1] = "PARTY"
	settings_channel.tab[2] = "RAID"
	settings_channel.tab[3] = "INSTANCE_CHAT"
	settings_channel.tab[4] = "YELL"
	settings_channel.tab[5] = "SAY"
	HealerProtection:CreateComboBox(settings_channel)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 30)
	HealerProtection:AppendCategory("aggro")
	HealerProtection:AppendCheckbox("aggro", true)
	HealerProtection:AppendCheckbox("showaggrochat", true)
	HealerProtection:AppendCheckbox("showaggroemote", true)
	HealerProtection:AppendSlider("AGGROPercentage", 50, 20, 100, 1, 0)
	HealerProtection:AppendCategory("outofmana")
	HealerProtection:AppendCheckbox("outofmana", true)
	HealerProtection:AppendCheckbox("showoomchat", true)
	HealerProtection:AppendCheckbox("showoomemote", true)
	HealerProtection:AppendSlider("OOMPercentage", 10, 1, 30, 1, 0)
	HealerProtection:AppendCategory("nearoutofmana")
	HealerProtection:AppendCheckbox("nearoutofmana", true)
	HealerProtection:AppendCheckbox("shownearoomchat", true)
	HealerProtection:AppendCheckbox("shownearoomemote", true)
	HealerProtection:AppendSlider("NEAROOMPercentage", 50, 10, 50, 1, 0)
	HealerProtection:AppendCategory("neardeath")
	HealerProtection:AppendCheckbox("neardeath", true)
	HealerProtection:AppendCheckbox("showneardeathchat", true)
	HealerProtection:AppendCheckbox("showneardeathemote", true)
	HealerProtection:AppendSlider("NEARDEATHPercentage", 50, 5, 40, 1, 0)
	HealerProtection:AppendCategory("extras")
	HealerProtection:AppendCheckbox("deathmessage", true)
	HealerProtection:AppendCheckbox("notinsight", false)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 30)
	local settings_prefix = {}
	settings_prefix.name = "prefix"
	settings_prefix.parent = HealerProtection:GetAppendParent()
	settings_prefix.value = HealerProtection:GetConfig("prefix", "[Healer Protection]")
	settings_prefix.text = "prefix"
	settings_prefix.x = 10
	settings_prefix.y = HealerProtection:GetAppendY()
	settings_prefix.dbvalue = "prefix"
	HealerProtection:CreateTextBox(settings_prefix)
	HealerProtection:SetAppendY(HealerProtection:GetAppendY() - 60)
	local settings_suffix = {}
	settings_suffix.name = "suffix"
	settings_suffix.parent = HealerProtection:GetAppendParent()
	settings_suffix.value = HealerProtection:GetConfig("suffix", "")
	settings_suffix.text = "suffix"
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
