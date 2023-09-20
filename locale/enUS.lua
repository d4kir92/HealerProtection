-- enUS English
local _, HealerProtection = ...
function HealerProtection:LangenUS()
	local lang = HealerProtection:GetLangTab()
	local elang = HealerProtection:GetELangTab()
	lang.aggro = "AGGRO"
	lang.showaggrochat = "AGGRO Chat-Message"
	lang.showaggroemote = "AGGRO Emote"
	lang.outofmana = "Out of Mana"
	lang.showoomchat = "OOM Chat-Message"
	lang.showoomemote = "OOM Emote"
	lang.nearoutofmana = "Near out of Mana"
	lang.shownearoomchat = "Near OOM Chat-Message"
	lang.shownearoomemote = "Near OOM Emote"
	lang.youhaveaggro = "You have AGGRO"
	lang.ihaveaggro = "I have AGGRO"
	lang.underhealthprintmessage = "If under VALUE% Health, print message"
	lang.undermanaprintmessage = "If under VALUE% Mana, print message"
	lang.xmana = "MANA% Mana"
	lang.xhealth = "HEALTH% Health"
	lang.prefix = "Prefix"
	lang.suffix = "Suffix"
	lang.printnothing = "Print Nothing"
	lang.showinraids = "Show in Raids"
	lang.showinbgs = "Show in Battlegrounds"
	lang.healerisdead = "Healer is dead"
	lang.deathmessage = "Death message"
	lang.neardeath = "Near death"
	lang.showneardeathchat = "Near death Chat-Message"
	lang.showneardeathemote = "Near death Emote"
	lang.notinsight = "Not in sight"
	lang.showoutsideofinstance = "Show Outside of Instances/Dungeons"
	for i, v in pairs(lang) do
		elang[i] = v
	end
end

HealerProtection:LangenUS()