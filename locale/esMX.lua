-- esMX Spain

local AddOnName, HealerProtection = ...

function HealerProtection:LangesMX()
	local lang = HealerProtection:GetLangTab()

	lang.aggro = "AGGRO"
	lang.showaggrochat = "Aggro Mensaje de Chat"
	lang.showaggroemote = "Aggri Emote"

	lang.outofmana = "Estoy sin Mana"
	lang.showoomchat = "Estoy sin Mana - Mensaje de Chat"
	lang.showoomemote = "Estoy sin Mana Emote"

	lang.nearoutofmana = "Cerca de quedarme sin Mana"
	lang.shownearoomchat = "Cerca de quedarme sin Mana - Mensaje de Chat"
	lang.shownearoomemote = "Cerca de quedarme sin Mana Emote"

	lang.youhaveaggro = "Tengo el Aggro, me atacan."
	lang.ihaveaggro = "Tengo el Aggro"

	lang.underhealthprintmessage = "Si está debajo de VALUE% Vida, imprimir mensaje"
	lang.undermanaprintmessage = "Si está debajo de VALUE% Mana, imprimir mensaje"

	lang.xmana = "MANA% Mana"
	lang.xhealth = "HEALTH% de Vida"

	lang.prefix = "Prefijo"
	lang.suffix = "Sufijo"

	lang.printnothing = "No imprimir nada"
	lang.showinraids = "Mostrar en Raid"
	lang.showinbgs = "Mostrar en Campos de Batalla"

	lang.healerisdead = "Ha muerto el Healer"
	lang.deathmessage = "Mensaje de Muerte"

	lang.neardeath = "Cercano a la muerte"
	lang.showneardeathchat = "Cercano a la muerte Mensaje de  Chat"
	lang.showneardeathemote = "Cercano a la muerte Emote"

	lang.notinsight = "No tengo visión"
end
