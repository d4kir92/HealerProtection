-- deDE German Deutsch

local AddOnName, HealerProtection = ...

function HealerProtection:LangdeDE()
	local lang = HealerProtection:GetLangTab()

	lang.aggro = "AGGRO"
	lang.showaggrochat = "AGGRO Chat-Nachricht"
	lang.showaggroemote = "AGGRO Emote"

	lang.outofmana = "Mana leer"
	lang.showoomchat = "Mana leer Chat-Nachricht"
	lang.showoomemote = "Mana leer Emote"

	lang.nearoutofmana = "Mana fast leer"
	lang.shownearoomchat = "Mana fast leer Chat-Nachricht"
	lang.shownearoomemote = "Mana fast leer Emote"

	lang.youhaveaggro = "Du hast AGGRO"
	lang.ihaveaggro = "Ich habe AGGRO"

	lang.underhealthprintmessage = "Wenn unter VALUE% Gesundheit, dann Nachricht senden"
	lang.undermanaprintmessage = "Wenn unter VALUE% Mana, dann Nachricht senden"

	lang.xmana = "MANA% Mana"
	lang.xhealth = "HEALTH% Gesundheit"

	lang.prefix = "Präfix"
	lang.suffix = "Suffix"

	lang.printnothing = "Nichts Schreiben"
	lang.showinraids = "In Schlachtzügen anzeigen"
	lang.showinbgs = "In Schlachtfeldern anzeigen"

	lang.healerisdead = "Heiler ist tot"
	lang.deathmessage = "Todesnachricht"

	lang.neardeath = "Dem Tod nahe"
	lang.showneardeathchat = "Dem Tod nahe Chat-Nachricht"
	lang.showneardeathemote = "Dem Tod nahe Emote"

	lang.notinsight = "Nicht in Sicht"
end
