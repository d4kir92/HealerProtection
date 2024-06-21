-- LIB Design
local _, HealerProtection = ...
function HealerProtection:CreateText(tab)
	tab.textsize = tab.textsize or 12
	local text = tab.frame:CreateFontString(nil, "ARTWORK")
	text:SetFont(STANDARD_TEXT_FONT, tab.textsize, "OUTLINE")
	text:SetPoint("TOPLEFT", tab.parent, "TOPLEFT", tab.x, tab.y)
	text:SetText(HealerProtection:Trans(tab.text))

	return text
end

function HealerProtection:CreateTextBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or UIParent
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	local f = CreateFrame("Button", nil, tab.parent)
	f:SetPoint("TOPLEFT", tab.x, tab.y)
	f:SetSize(250, 50)
	tab.frame = f
	tab.parent = f
	tab.x = 4
	tab.y = -4
	tab.text = tab.text
	f.header = HealerProtection:CreateText(tab)
	f.Text = CreateFrame("EditBox", nil, f)
	f.Text:SetPoint("TOPRIGHT", -2, -25)
	f.Text:SetPoint("BOTTOMLEFT", 2, 2)
	f.Text:SetMultiLine(false)
	f.Text:SetMaxLetters(20)
	f.Text:SetFontObject(GameFontNormal)
	f.Text:SetAutoFocus(false)
	tab.value = tab.value or ""
	tab.value = string.gsub(tab.value, "\n", "")
	f.Text:SetText(tab.value or "")
	f.Text:SetCursorPosition(0)
	f.Text:SetScript(
		"OnTextChanged",
		function(sel)
			local text = sel:GetText()
			sel:SetText(text)
			HPTABPC[tab.dbvalue] = text
			HealerProtection:Setup()
		end
	)

	return f
end

function HealerProtection:CreateComboBox(tab)
	tab = tab or {}
	tab.parent = tab.parent or UIParent
	tab.tooltip = tab.tooltip or ""
	tab.x = tab.x or 0
	tab.y = tab.y or 0
	local rows = {
		["name"] = tab.name,
		["parent"] = tab.parent,
		["title"] = tab.text,
		["items"] = tab.tab,
		["defaultVal"] = tab.value,
		["changeFunc"] = function(dropdown_frame, dropdown_val)
			--dropdown_val = tonumber( dropdown_val )
			HPTABPC[tab.dbvalue] = dropdown_val
		end
	}

	local DD = HealerProtection:CreateDropdown(rows)
	DD:SetPoint("TOPLEFT", tab.parent, "TOPLEFT", tab.x, tab.y)

	return DD
end
