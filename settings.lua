-- By D4KiR
local AddonName, HealerProtection = ...
local hpset = nil
local DEFAULT_WIDTH = 520
local DEFAULT_HEIGHT = 520
function HealerProtection:ToggleSettings()
	if hpset == nil then return end
	hpset:Toggle()
end

local function GetCollapsed(key)
	if key == nil then return nil end
	if type(HPTABPC) ~= "table" then return nil end
	if type(HPTABPC["COLLAPSED"]) ~= "table" then return nil end
	return HPTABPC["COLLAPSED"][key]
end

local function SetCollapsed(key, collapsed)
	if key == nil then return end
	if type(HPTABPC) ~= "table" then return end
	if type(HPTABPC["COLLAPSED"]) ~= "table" then HPTABPC["COLLAPSED"] = {} end
	if collapsed then
		HPTABPC["COLLAPSED"][key] = true
	else
		HPTABPC["COLLAPSED"][key] = nil
	end
end

local function AddCategory(key, level)
	hpset:AddCategory({
		["label"] = "LID_" .. key,
		["key"] = key,
		["search"] = key,
		["level"] = level
	})
end

local LABELS = {
	["AGGRO"] = "aggro",
	["OOM"] = "outofmana",
	["NEAROOM"] = "nearoutofmana",
	["NEARDEATH"] = "neardeath",
	["DRINKINGEATING"] = "drinkingeating",
}

local function AddCheckbox(key, default, func)
	local label = LABELS[key] or key
	local search = key
	if label ~= key then search = key .. " " .. label end
	hpset:AddCheckbox({
		["label"] = "LID_" .. label,
		["search"] = search,
		["value"] = HealerProtection:DBGV(key, default),
		["func"] = function(value)
			HealerProtection:DBSV(key, value)
			if func then func() end
		end
	})
end

local function AddSlider(key, default, min, max, step, decimals, func)
	hpset:AddSlider({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = HealerProtection:DBGV(key, default),
		["min"] = min,
		["max"] = max,
		["step"] = step,
		["decimals"] = decimals,
		["func"] = function(value)
			HealerProtection:DBSV(key, value)
			if func then func() end
		end
	})
end

local function AddEditbox(key, default)
	hpset:AddEditbox({
		["label"] = "LID_" .. key,
		["search"] = key,
		["value"] = HealerProtection:DBGV(key, default),
		["maxLetters"] = 20,
		["func"] = function(value) HealerProtection:DBSV(key, value) end
	})
end

function HealerProtection:InitSetting()
	HPTABPC = HPTABPC or {}
	HPTABPC["MMBTNTAB"] = HPTABPC["MMBTNTAB"] or {}
	if HPTABPC["MMBTN"] == nil then
		HPTABPC["MMBTN"] = HealerProtection:GetWoWBuild() ~= "RETAIL"
	end

	HealerProtection:AddSlash("hp", HealerProtection.ToggleSettings)
	HealerProtection:AddSlash("healerprotection", HealerProtection.ToggleSettings)
	hpset = HealerProtection:CreateUIWindow(
		{
			["name"] = "HealerProtectionSettings",
			["pTab"] = {"CENTER"},
			["width"] = HealerProtection:DBGV("WINDOWWIDTH", DEFAULT_WIDTH),
			["height"] = HealerProtection:DBGV("WINDOWHEIGHT", DEFAULT_HEIGHT),
			["minWidth"] = 360,
			["minHeight"] = 240,
			["onResize"] = function(width, height)
				HealerProtection:DBSV("WINDOWWIDTH", width)
				HealerProtection:DBSV("WINDOWHEIGHT", height)
			end,
			["getCollapsed"] = function(key) return GetCollapsed(key) end,
			["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
			["title"] = string.format("|T135923:16:16:0:0|t HealerProtection by |cff55d2ffD4KiR |T132115:16:16:0:0|t v%s", HealerProtection:GetVersion())
		}
	)

	hpset:SetFrameLevel(110)
	hpset:SuspendLayout()
	hpset:AddSearch()
	AddCategory("general")
	AddCheckbox(
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

	AddCheckbox("printnothing", false)
	AddCategory("visibility")
	AddCheckbox("showasnothealer", false)
	AddCheckbox("showinraids", true)
	AddCheckbox("showinbgs", false)
	AddCheckbox("showoutsideofinstance", false)
	AddCategory("output")
	hpset:AddDropdown(
		{
			["label"] = "LID_channelchat",
			["search"] = "channelchat",
			["value"] = HealerProtection:DBGV("channelchat", "AUTO"),
			["choices"] = {
				{
					["value"] = "AUTO",
					["label"] = "LID_AUTO"
				},
				{
					["value"] = "PARTY",
					["label"] = "LID_PARTY"
				},
				{
					["value"] = "RAID",
					["label"] = "LID_RAID"
				},
				{
					["value"] = "INSTANCE_CHAT",
					["label"] = "LID_INSTANCE_CHAT"
				},
				{
					["value"] = "YELL",
					["label"] = "LID_YELL"
				},
				{
					["value"] = "SAY",
					["label"] = "LID_SAY"
				},
			},
			["func"] = function(value) HealerProtection:DBSV("channelchat", value) end
		}
	)

	AddEditbox("prefix", "[Healer Protection]")
	AddEditbox("suffix", "")
	AddCategory("language", 2)
	AddCheckbox("showtranslation", true)
	AddCheckbox("showonlyenglish", false)
	AddCheckbox("showonlytranslation", false)
	AddCategory("alerts")
	AddCheckbox("deathmessage", true)
	AddCheckbox("notinsight", false)
	if HealerProtection:GetWoWBuildNr() < 120000 then
		AddCategory("aggro", 2)
		AddCheckbox("AGGRO", true)
		AddCheckbox("showaggrochat", true)
		AddCheckbox("showaggroemote", true)
		AddSlider("AGGROPercentage", 50, 20, 100, 1, 0)
	end

	AddCategory("outofmana", 2)
	AddCheckbox("OOM", true)
	AddCheckbox("showoomchat", true)
	AddCheckbox("showoomemote", true)
	AddSlider("OOMPercentage", 10, 1, 30, 1, 0)
	AddCategory("nearoutofmana", 2)
	AddCheckbox("NEAROOM", true)
	AddCheckbox("shownearoomchat", true)
	AddCheckbox("shownearoomemote", true)
	AddSlider("NEAROOMPercentage", 50, 10, 50, 1, 0)
	AddCategory("neardeath", 2)
	AddCheckbox("NEARDEATH", true)
	AddCheckbox("showneardeathchat", true)
	AddCheckbox("showneardeathemote", true)
	AddSlider("NEARDEATHPercentage", 50, 5, 40, 1, 0)
	AddCategory("drinkingeating", 2)
	AddCheckbox("DRINKINGEATING", true)
	AddCheckbox("showdrinkingeatingchat", true)
	AddCheckbox("showdrinkingeatingemote", true)
	hpset:ResumeLayout()
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

			HealerProtection:SetVersion(135923, "1.2.105")
			HealerProtection:CreateMinimapButton(
				{
					["name"] = "HealerProtection",
					["icon"] = 135923,
					["dbtab"] = HPTABPC,
					["vTT"] = {{"|T135923:16:16:0:0|t HealerProtection", "v" .. HealerProtection:GetVersion()}, {HealerProtection:Trans("LID_LEFTCLICK"), HealerProtection:Trans("LID_OPENSETTINGS")}, {HealerProtection:Trans("LID_RIGHTCLICK"), HealerProtection:Trans("LID_HIDEMINIMAPBUTTON")}},
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
