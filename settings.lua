-- By D4KiR
local AddonName, HealerProtection = ...
function HealerProtection:InitSetting()
	local HPTAB_Settings = {}
	D4:SetVersion(AddonName, 135923, "1.1.7")
	HPTAB_Settings.panel = CreateFrame("Frame", "HPTAB_Settings", UIParent)
	HPTAB_Settings.panel.name = "HealerProtection |T135923:16:16:0:0|t by |cff3FC7EBD4KiR |T132115:16:16:0:0|t"
	local BR = 16
	local HR = 10
	local DR = 22
	local SR = 30
	local Y = -10
	local settings_header = {}
	settings_header.frame = HPTAB_Settings.panel
	settings_header.parent = HPTAB_Settings.panel
	settings_header.x = 10
	settings_header.y = Y
	settings_header.text = HPTAB_Settings.panel.name
	settings_header.textsize = 24
	HealerProtection:CreateText(settings_header)
	Y = Y - 30
	local settings_printnothing = {}
	settings_printnothing.name = "printnothing"
	settings_printnothing.parent = HPTAB_Settings.panel
	settings_printnothing.checked = HealerProtection:GetConfig("printnothing", false)
	settings_printnothing.text = "printnothing"
	settings_printnothing.x = 10
	settings_printnothing.y = Y
	settings_printnothing.dbvalue = "printnothing"
	HealerProtection:CreateCheckBox(settings_printnothing)
	Y = Y - BR
	if UnitGroupRolesAssigned and HealerProtection:GetWoWBuildNr() > 19999 then
		local settings_showasnothealer = {}
		settings_showasnothealer.name = "showasnothealer"
		settings_showasnothealer.parent = HPTAB_Settings.panel
		settings_showasnothealer.checked = HealerProtection:GetConfig("showasnothealer", false)
		settings_showasnothealer.text = "showasnothealer"
		settings_showasnothealer.x = 10
		settings_showasnothealer.y = Y
		settings_showasnothealer.dbvalue = "showasnothealer"
		HealerProtection:CreateCheckBox(settings_showasnothealer)
		Y = Y - BR
	end

	local settings_showinraids = {}
	settings_showinraids.name = "showinraids"
	settings_showinraids.parent = HPTAB_Settings.panel
	settings_showinraids.checked = HealerProtection:GetConfig("showinraids", true)
	settings_showinraids.text = "showinraids"
	settings_showinraids.x = 10
	settings_showinraids.y = Y
	settings_showinraids.dbvalue = "showinraids"
	HealerProtection:CreateCheckBox(settings_showinraids)
	Y = Y - BR
	local settings_showoutsideofinstance = {}
	settings_showoutsideofinstance.name = "showoutsideofinstance"
	settings_showoutsideofinstance.parent = HPTAB_Settings.panel
	settings_showoutsideofinstance.checked = HealerProtection:GetConfig("showoutsideofinstance", false)
	settings_showoutsideofinstance.text = "showoutsideofinstance"
	settings_showoutsideofinstance.x = 10
	settings_showoutsideofinstance.y = Y
	settings_showoutsideofinstance.dbvalue = "showoutsideofinstance"
	HealerProtection:CreateCheckBox(settings_showoutsideofinstance)
	Y = Y - DR
	local settings_showinbgs = {}
	settings_showinbgs.name = "showinbgs"
	settings_showinbgs.parent = HPTAB_Settings.panel
	settings_showinbgs.checked = HealerProtection:GetConfig("showinbgs", false)
	settings_showinbgs.text = "showinbgs"
	settings_showinbgs.x = 10
	settings_showinbgs.y = Y
	settings_showinbgs.dbvalue = "showinbgs"
	HealerProtection:CreateCheckBox(settings_showinbgs)
	Y = Y - DR
	local settings_aggro = {}
	settings_aggro.name = "aggro"
	settings_aggro.parent = HPTAB_Settings.panel
	settings_aggro.checked = HealerProtection:GetConfig("AGGRO", true)
	settings_aggro.text = "aggro"
	settings_aggro.x = 10
	settings_aggro.y = Y
	settings_aggro.dbvalue = "AGGRO"
	HealerProtection:CreateCheckBox(settings_aggro)
	local settings_deathmessage = {}
	settings_deathmessage.name = "deathmessage"
	settings_deathmessage.parent = HPTAB_Settings.panel
	settings_deathmessage.checked = HealerProtection:GetConfig("deathmessage", true)
	settings_deathmessage.text = "deathmessage"
	settings_deathmessage.x = 200
	settings_deathmessage.y = Y - 30
	settings_deathmessage.dbvalue = "deathmessage"
	HealerProtection:CreateCheckBox(settings_deathmessage)
	local settings_notinsight = {}
	settings_notinsight.name = "notinsight"
	settings_notinsight.parent = HPTAB_Settings.panel
	settings_notinsight.checked = HealerProtection:GetConfig("notinsight", false)
	settings_notinsight.text = "notinsight"
	settings_notinsight.x = 390
	settings_notinsight.y = Y - 30
	settings_notinsight.dbvalue = "notinsight"
	HealerProtection:CreateCheckBox(settings_notinsight)
	Y = Y - BR
	local settings_showaggrochat = {}
	settings_showaggrochat.name = "showaggrochat"
	settings_showaggrochat.parent = HPTAB_Settings.panel
	settings_showaggrochat.checked = HealerProtection:GetConfig("showaggrochat", true)
	settings_showaggrochat.text = "showaggrochat"
	settings_showaggrochat.x = 10
	settings_showaggrochat.y = Y
	settings_showaggrochat.dbvalue = "showaggrochat"
	HealerProtection:CreateCheckBox(settings_showaggrochat)
	Y = Y - BR
	local settings_showaggroemote = {}
	settings_showaggroemote.name = "showaggroemote"
	settings_showaggroemote.parent = HPTAB_Settings.panel
	settings_showaggroemote.checked = HealerProtection:GetConfig("showaggroemote", true)
	settings_showaggroemote.text = "showaggroemote"
	settings_showaggroemote.x = 10
	settings_showaggroemote.y = Y
	settings_showaggroemote.dbvalue = "showaggroemote"
	HealerProtection:CreateCheckBox(settings_showaggroemote)
	Y = Y - SR
	local settings_aggro_percentage = {}
	settings_aggro_percentage.name = "underhealthprintmessage"
	settings_aggro_percentage.parent = HPTAB_Settings.panel
	settings_aggro_percentage.text = "underhealthprintmessage"
	settings_aggro_percentage.x = 10 + 30
	settings_aggro_percentage.y = Y
	settings_aggro_percentage.min = 20
	settings_aggro_percentage.max = 100
	settings_aggro_percentage.value = HealerProtection:GetConfig("AGGROPercentage", 50)
	settings_aggro_percentage.dbvalue = "AGGROPercentage"
	HealerProtection:CreateSlider(settings_aggro_percentage)
	Y = Y - BR
	Y = Y - HR
	local settings_oom = {}
	settings_oom.name = "outofmana"
	settings_oom.parent = HPTAB_Settings.panel
	settings_oom.checked = HealerProtection:GetConfig("OOM", true)
	settings_oom.text = "outofmana"
	settings_oom.x = 10
	settings_oom.y = Y
	settings_oom.dbvalue = "OOM"
	HealerProtection:CreateCheckBox(settings_oom)
	Y = Y - BR
	local settings_showoomchat = {}
	settings_showoomchat.name = "showoomchat"
	settings_showoomchat.parent = HPTAB_Settings.panel
	settings_showoomchat.checked = HealerProtection:GetConfig("showoomchat", true)
	settings_showoomchat.text = "showoomchat"
	settings_showoomchat.x = 10
	settings_showoomchat.y = Y
	settings_showoomchat.dbvalue = "showoomchat"
	HealerProtection:CreateCheckBox(settings_showoomchat)
	Y = Y - BR
	local settings_showoomemote = {}
	settings_showoomemote.name = "showoomemote"
	settings_showoomemote.parent = HPTAB_Settings.panel
	settings_showoomemote.checked = HealerProtection:GetConfig("showoomemote", true)
	settings_showoomemote.text = "showoomemote"
	settings_showoomemote.x = 10
	settings_showoomemote.y = Y
	settings_showoomemote.dbvalue = "showoomemote"
	HealerProtection:CreateCheckBox(settings_showoomemote)
	Y = Y - SR
	local settings_oom_percentage = {}
	settings_oom_percentage.name = "undermanaprintmessage"
	settings_oom_percentage.parent = HPTAB_Settings.panel
	settings_oom_percentage.text = "undermanaprintmessage"
	settings_oom_percentage.x = 10 + 30
	settings_oom_percentage.y = Y
	settings_oom_percentage.min = 1
	settings_oom_percentage.max = 30
	settings_oom_percentage.value = HealerProtection:GetConfig("OOMPercentage", 10)
	settings_oom_percentage.dbvalue = "OOMPercentage"
	SETOOMP = HealerProtection:CreateSlider(settings_oom_percentage)
	Y = Y - BR
	Y = Y - HR
	local settings_nearoom = {}
	settings_nearoom.name = "nearoutofmana"
	settings_nearoom.parent = HPTAB_Settings.panel
	settings_nearoom.checked = HealerProtection:GetConfig("NEAROOM", true)
	settings_nearoom.text = "nearoutofmana"
	settings_nearoom.x = 10
	settings_nearoom.y = Y
	settings_nearoom.dbvalue = "NEAROOM"
	HealerProtection:CreateCheckBox(settings_nearoom)
	Y = Y - BR
	local settings_shownearoomchat = {}
	settings_shownearoomchat.name = "shownearoomchat"
	settings_shownearoomchat.parent = HPTAB_Settings.panel
	settings_shownearoomchat.checked = HealerProtection:GetConfig("shownearoomchat", true)
	settings_shownearoomchat.text = "shownearoomchat"
	settings_shownearoomchat.x = 10
	settings_shownearoomchat.y = Y
	settings_shownearoomchat.dbvalue = "shownearoomchat"
	HealerProtection:CreateCheckBox(settings_shownearoomchat)
	Y = Y - BR
	local settings_shownearoomemote = {}
	settings_shownearoomemote.name = "shownearoomemote"
	settings_shownearoomemote.parent = HPTAB_Settings.panel
	settings_shownearoomemote.checked = HealerProtection:GetConfig("shownearoomemote", true)
	settings_shownearoomemote.text = "shownearoomemote"
	settings_shownearoomemote.x = 10
	settings_shownearoomemote.y = Y
	settings_shownearoomemote.dbvalue = "shownearoomemote"
	HealerProtection:CreateCheckBox(settings_shownearoomemote)
	Y = Y - SR
	local settings_nearoom_percentage = {}
	settings_nearoom_percentage.name = "undermanaprintmessage"
	settings_nearoom_percentage.parent = HPTAB_Settings.panel
	settings_nearoom_percentage.text = "undermanaprintmessage"
	settings_nearoom_percentage.x = 10 + 30
	settings_nearoom_percentage.y = Y
	settings_nearoom_percentage.min = 10
	settings_nearoom_percentage.max = 50
	settings_nearoom_percentage.value = HealerProtection:GetConfig("NEAROOMPercentage", 30)
	settings_nearoom_percentage.dbvalue = "NEAROOMPercentage"
	SETNEAROOMP = HealerProtection:CreateSlider(settings_nearoom_percentage)
	Y = Y - BR
	Y = Y - HR
	local settings_neardeath = {}
	settings_neardeath.name = "neardeath"
	settings_neardeath.parent = HPTAB_Settings.panel
	settings_neardeath.checked = HealerProtection:GetConfig("NEARDEATH", true)
	settings_neardeath.text = "neardeath"
	settings_neardeath.x = 10
	settings_neardeath.y = Y
	settings_neardeath.dbvalue = "NEARDEATH"
	HealerProtection:CreateCheckBox(settings_neardeath)
	Y = Y - BR
	local settings_showneardeathchat = {}
	settings_showneardeathchat.name = "showneardeathchat"
	settings_showneardeathchat.parent = HPTAB_Settings.panel
	settings_showneardeathchat.checked = HealerProtection:GetConfig("showneardeathchat", true)
	settings_showneardeathchat.text = "showneardeathchat"
	settings_showneardeathchat.x = 10
	settings_showneardeathchat.y = Y
	settings_showneardeathchat.dbvalue = "showneardeathchat"
	HealerProtection:CreateCheckBox(settings_showneardeathchat)
	Y = Y - BR
	local settings_showneardeathemote = {}
	settings_showneardeathemote.name = "showneardeathemote"
	settings_showneardeathemote.parent = HPTAB_Settings.panel
	settings_showneardeathemote.checked = HealerProtection:GetConfig("showneardeathemote", true)
	settings_showneardeathemote.text = "showneardeathemote"
	settings_showneardeathemote.x = 10
	settings_showneardeathemote.y = Y
	settings_showneardeathemote.dbvalue = "showneardeathemote"
	HealerProtection:CreateCheckBox(settings_showneardeathemote)
	Y = Y - SR
	local settings_neardeath_percentage = {}
	settings_neardeath_percentage.name = "underhealthprintmessage"
	settings_neardeath_percentage.parent = HPTAB_Settings.panel
	settings_neardeath_percentage.text = "underhealthprintmessage"
	settings_neardeath_percentage.x = 10 + 30
	settings_neardeath_percentage.y = Y
	settings_neardeath_percentage.min = 5
	settings_neardeath_percentage.max = 40
	settings_neardeath_percentage.value = HealerProtection:GetConfig("NEARDEATHPercentage", 20)
	settings_neardeath_percentage.dbvalue = "NEARDEATHPercentage"
	SETNEARDEATHP = HealerProtection:CreateSlider(settings_neardeath_percentage)
	Y = Y - BR
	Y = Y - SR
	local settings_channel = {}
	settings_channel.name = "channelchat"
	settings_channel.parent = HPTAB_Settings.panel
	settings_channel.text = "channelchat"
	settings_channel.value = HealerProtection:GetConfig("channelchat", "AUTO")
	settings_channel.x = 0
	settings_channel.y = Y
	settings_channel.dbvalue = "channelchat"
	settings_channel.tab = {}
	settings_channel.tab[0] = "AUTO"
	settings_channel.tab[1] = "PARTY"
	settings_channel.tab[2] = "RAID"
	settings_channel.tab[3] = "INSTANCE_CHAT"
	HealerProtection:CreateComboBox(settings_channel)
	Y = Y - SR
	local settings_showtranslation = {}
	settings_showtranslation.name = "showtranslation"
	settings_showtranslation.parent = HPTAB_Settings.panel
	settings_showtranslation.checked = HealerProtection:GetConfig("showtranslation", true)
	settings_showtranslation.text = "Show Translation"
	settings_showtranslation.x = 10
	settings_showtranslation.y = Y
	settings_showtranslation.dbvalue = "showtranslation"
	HealerProtection:CreateCheckBox(settings_showtranslation)
	local settings_showonlyenglish = {}
	settings_showonlyenglish.name = "showonlyenglish"
	settings_showonlyenglish.parent = HPTAB_Settings.panel
	settings_showonlyenglish.checked = HealerProtection:GetConfig("showonlyenglish", false)
	settings_showonlyenglish.text = "Show Only English"
	settings_showonlyenglish.x = 210
	settings_showonlyenglish.y = Y
	settings_showonlyenglish.dbvalue = "showonlyenglish"
	HealerProtection:CreateCheckBox(settings_showonlyenglish)
	local settings_showonlytranslation = {}
	settings_showonlytranslation.name = "showonlytranslation"
	settings_showonlytranslation.parent = HPTAB_Settings.panel
	settings_showonlytranslation.checked = HealerProtection:GetConfig("showonlytranslation", false)
	settings_showonlytranslation.text = "Show Only Translation"
	settings_showonlytranslation.x = 410
	settings_showonlytranslation.y = Y
	settings_showonlytranslation.dbvalue = "showonlytranslation"
	HealerProtection:CreateCheckBox(settings_showonlytranslation)
	Y = Y - SR
	local settings_prefix = {}
	settings_prefix.name = "prefix"
	settings_prefix.parent = HPTAB_Settings.panel
	settings_prefix.value = HealerProtection:GetConfig("prefix", "[Healer Protection]")
	settings_prefix.text = "prefix"
	settings_prefix.x = 10
	settings_prefix.y = Y
	settings_prefix.dbvalue = "prefix"
	HealerProtection:CreateTextBox(settings_prefix)
	local settings_suffix = {}
	settings_suffix.name = "suffix"
	settings_suffix.parent = HPTAB_Settings.panel
	settings_suffix.value = HealerProtection:GetConfig("suffix", "")
	settings_suffix.text = "suffix"
	settings_suffix.x = 10 + 250 + 10
	settings_suffix.y = Y
	settings_suffix.dbvalue = "suffix"
	HealerProtection:CreateTextBox(settings_suffix)
	Y = Y - BR
	InterfaceOptions_AddCategory(HPTAB_Settings.panel)
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
		--HealerProtection:SetupHP()
	end

	if event == "ADDON_LOADED" then
		addo = true
		--HealerProtection:SetupHP()
	end

	if vars and addo and not HealerProtection:IsLoaded() then
		HPloaded = true
		C_Timer.After(
			0,
			function()
				HealerProtection:SetSetup(true)
				HealerProtection:SetupHP()
			end
		)
	end
end

frame:SetScript("OnEvent", frame.OnEvent)