-- frFR French
local _, HealerProtection = ...

function HealerProtection:LangfrFR()
	local lang = HealerProtection:GetLangTab()
	lang.aggro = "AGGRO"
	lang.showaggrochat = "AGGRO Message dans le Chat"
	lang.showaggroemote = "AGGRO Emote"
	lang.outofmana = "Plus de Mana"
	lang.showoomchat = "Plus de Mana Chat-Message"
	lang.showoomemote = "OOM Emote"
	lang.nearoutofmana = "Mana faible"
	lang.shownearoomchat = "Presque plus de Mana"
	lang.shownearoomemote = "Presque OOM Emote"
	lang.youhaveaggro = "Vous avez AGGRO"
	lang.ihaveaggro = "AGGRO sur moi"
	lang.underhealthprintmessage = "Si vous êtes sous VALUE% de santé, afficher le message"
	lang.undermanaprintmessage = "Si vous êtes sous VALUE% de mana, afficher le message"
	lang.xmana = "MANA% Mana"
	lang.xhealth = "HEALTH% de Vie"
	lang.prefix = "Préfixe"
	lang.suffix = "Suffixe"
	lang.printnothing = "Ne rien afficher"
	lang.showinraids = "Afficher en Raids"
	lang.showinbgs = "Afficher en Champs de Bataille"
	lang.healerisdead = "Le Heal est Mort"
	lang.deathmessage = "Message lorsque Mort"
	lang.neardeath = "Bientôt Trépassé"
	lang.showneardeathchat = "Bientôt Trépassé Chat-Message"
	lang.showneardeathemote = "Bientôt Trépassé Emote"
	lang.notinsight = "Cible Masquée/Hors de Vue"
end