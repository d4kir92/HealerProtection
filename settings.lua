-- By D4KiR
local AddonName, HealerProtection = ...
local hpset = nil
local DEFAULT_WIDTH = 640
local DEFAULT_HEIGHT = 520
local LANGUAGES = {{"English", "enUS"}, {"Deutsch", "deDE"}, {"Español (España)", "esES"}, {"Español (México)", "esMX"}, {"Français", "frFR"}, {"Italiano", "itIT"}, {"한국어", "koKR"}, {"Português (Brasil)", "ptBR"}, {"Русский", "ruRU"}, {"简体中文", "zhCN"}, {"繁體中文", "zhTW"}}
local languageNames = {}
for _, info in ipairs(LANGUAGES) do
	languageNames[info[2]] = info[1]
end

function HealerProtection:GetLanguage()
	local lang = type(HPTAB) == "table" and HPTAB["LANGUAGE"] or nil
	if lang ~= nil and languageNames[lang] ~= nil then return lang end
	if languageNames[GetLocale()] ~= nil then return GetLocale() end

	return "enUS"
end

HealerProtection.LibTrans = HealerProtection.Trans
function HealerProtection:Trans(key, lang, ...)
	return HealerProtection.LibTrans(self, key, lang or HealerProtection:GetLanguage(), ...)
end

function HealerProtection:SetLanguage(lang)
	if languageNames[lang] == nil or lang == HealerProtection:GetLanguage() then return end
	HPTAB = HPTAB or {}
	if lang == GetLocale() then
		HPTAB["LANGUAGE"] = nil
	else
		HPTAB["LANGUAGE"] = lang
	end

	if hpset ~= nil then
		hpset:RefreshLanguage()
		if hpset.hpRefreshLanguageButton then hpset.hpRefreshLanguageButton() end
	end
end

local function LanguageMenu(_, root)
	root:CreateTitle(HealerProtection:Trans("LID_language"))
	for _, info in ipairs(LANGUAGES) do
		local lang = info[2]
		root:CreateRadio(string.format("%s (%s)", info[1], lang), function() return HealerProtection:GetLanguage() == lang end, function() HealerProtection:SetLanguage(lang) end)
	end
end

function HealerProtection:AddLanguageButton(win)
	local parent = win.titleBar or win
	local button
	if HealerProtection:GetWoWBuild() == "RETAIL" and HealerProtection:CheckTemplates("WowStyle1DropdownTemplate") then
		button = CreateFrame("DropdownButton", nil, parent, "WowStyle1DropdownTemplate")
		button:SetScale(0.8)
		button:SetSize(162.5, 25)
		button:SetPoint("TOPLEFT", parent, "TOPLEFT", 10, -1.25)
		button:SetSelectionText(function() return languageNames[HealerProtection:GetLanguage()] end)
		button:SetTooltip(function(tooltip) tooltip:SetText(HealerProtection:Trans("LID_language")) end)
		button:SetupMenu(LanguageMenu)
	else
		button = HealerProtection:CreateButton(nil, parent)
		button:SetSize(130, 20)
		button:SetPoint("TOPLEFT", parent, "TOPLEFT", 7, -2)
		button.Arrow = button:CreateTexture(nil, "OVERLAY")
		button.Arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
		button.Arrow:SetSize(16, 16)
		button.Arrow:SetPoint("RIGHT", button, "RIGHT", -2, 0)
		button:SetScript(
			"OnClick",
			function(sel)
				if MenuUtil and MenuUtil.CreateContextMenu then
					MenuUtil.CreateContextMenu(sel, LanguageMenu)
				else
					local current = 1
					for index, info in ipairs(LANGUAGES) do
						if info[2] == HealerProtection:GetLanguage() then
							current = index
						end
					end

					HealerProtection:SetLanguage(LANGUAGES[current % #LANGUAGES + 1][2])
				end
			end
		)

		button:SetScript(
			"OnEnter",
			function(sel)
				GameTooltip:SetOwner(sel, "ANCHOR_RIGHT")
				GameTooltip:SetText(HealerProtection:Trans("LID_language"))
				GameTooltip:Show()
			end
		)

		button:SetScript("OnLeave", function() GameTooltip:Hide() end)
	end

	local function RefreshButton()
		button:SetText(languageNames[HealerProtection:GetLanguage()])
	end

	RefreshButton()
	win.Language = button

	return RefreshButton
end

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

	local function OnSlash(args)
		if type(args) == "string" and string.lower(strtrim(args)) == "debug" then
			HealerProtection:ToggleDebug()
		else
			HealerProtection:ToggleSettings()
		end
	end

	HealerProtection:AddSlash("hp", OnSlash)
	HealerProtection:AddSlash("healerprotection", OnSlash)
	hpset = HealerProtection:CreateUIWindow(
		{
			["name"] = "HealerProtectionSettings",
			["pTab"] = {"CENTER"},
			["width"] = HealerProtection:DBGV("WINDOWWIDTH", DEFAULT_WIDTH),
			["height"] = HealerProtection:DBGV("WINDOWHEIGHT", DEFAULT_HEIGHT),
			["minWidth"] = 460,
			["minHeight"] = 240,
			["navigation"] = true,
			["onResize"] = function(width, height)
				HealerProtection:DBSV("WINDOWWIDTH", width)
				HealerProtection:DBSV("WINDOWHEIGHT", height)
			end,
			["getCollapsed"] = function(key) return GetCollapsed(key) end,
			["setCollapsed"] = function(key, collapsed) SetCollapsed(key, collapsed) end,
			["title"] = string.format("|T%s:16:16:0:0|t HealerProtection by |cff55d2ffD4KiR |T132115:16:16:0:0|t v%s", HealerProtection:GetAddonIcon(), HealerProtection:GetVersion())
		}
	)

	hpset.hpRefreshLanguageButton = HealerProtection:AddLanguageButton(hpset)
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
	hpset:AddDropdown(
		{
			["label"] = "LID_LANGMODE",
			["search"] = "LANGMODE",
			["value"] = HealerProtection:GetLangMode(),
			["choices"] = {
				{
					["value"] = "BOTH",
					["label"] = "LID_englishandtranslation"
				},
				{
					["value"] = "ENGLISH",
					["label"] = "LID_showonlyenglish"
				},
				{
					["value"] = "TRANSLATION",
					["label"] = "LID_showonlytranslation"
				},
			},
			["func"] = function(value) HealerProtection:DBSV("LANGMODE", value) end
		}
	)
	AddCategory("alerts")
	AddCheckbox("deathmessage", true)
	AddCheckbox("notinsight", false)
	AddSlider("REPEATCOOLDOWN", 20, 0, 120, 1, 0)
	AddCategory("aggro", 2)
	AddCheckbox("AGGRO", true)
	AddCheckbox("showaggrochat", true)
	AddCheckbox("showaggroemote", true)
	if not HealerProtection:IsSecretClient() then
		AddSlider("AGGROPercentage", 50, 20, 100, 1, 0)
	end

	AddCategory("outofmana", 2)
	AddCheckbox("OOM", true)
	AddCheckbox("showoomchat", true)
	AddCheckbox("showoomemote", true)
	local manaReadable = HealerProtection:PublicNumber("player", UnitPowerMax) ~= nil
	if manaReadable then
		AddSlider("OOMPercentage", 10, 1, 30, 1, 0)
	end

	AddCheckbox("IGNOREMAXMANADRAIN", true)
	AddCategory("nearoutofmana", 2)
	AddCheckbox("NEAROOM", true)
	AddCheckbox("shownearoomchat", true)
	AddCheckbox("shownearoomemote", true)
	if manaReadable then
		AddSlider("NEAROOMPercentage", 50, 10, 50, 1, 0)
	end
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

			HealerProtection:SetVersion()
			HealerProtection:CreateMinimapButton(
				{
					["name"] = "HealerProtection",
					["icon"] = HealerProtection:GetAddonIcon(),
					["dbtab"] = HPTABPC,
					["vTT"] = {{string.format("|T%s:16:16:0:0|t HealerProtection", HealerProtection:GetAddonIcon()),"v" .. HealerProtection:GetVersion()}, {HealerProtection:Trans("LID_LEFTCLICK"), HealerProtection:Trans("LID_OPENSETTINGS")}, {HealerProtection:Trans("LID_RIGHTCLICK"), HealerProtection:Trans("LID_HIDEMINIMAPBUTTON")}},
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
