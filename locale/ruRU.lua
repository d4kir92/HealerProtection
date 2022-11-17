-- ruRU Russian

local AddOnName, HealerProtection = ...

function HealerProtection:LangruRU()
	local lang = HealerProtection:GetLangTab()

	lang.aggro = "АГРО"
	lang.showaggrochat = "Сообщение в чате об АГРО"
	lang.showaggroemote = "АГРО/эмоция"

	lang.outofmana = "НЕТ МАНЫ"
	lang.showoomchat = "Сообщение в чат, когда НЕТ МАНЫ"
	lang.showoomemote = "НЕТ МАНЫ/эмоция"

	lang.nearoutofmana = "Почти нет Маны"
	lang.shownearoomchat = "Сообщение в чате, когда почти нет Маны"
	lang.shownearoomemote = "Почти нет Маны/эмоция"

	lang.youhaveaggro = "На вас АГРО"
	lang.ihaveaggro = "На мне АГРО"

	lang.underhealthprintmessage = "Сообщение в чат, если Здоровье упадет ниже VALUE%"
	lang.undermanaprintmessage = "Сообщение в чат, если Мана упадет ниже VALUE%"

	lang.xmana = "MANA% Маны"
	lang.xhealth = "HEALTH% Здоровье"

	lang.prefix = "Префикс"
	lang.suffix = "Суффикс"

	lang.printnothing = "Ничего не печатать"
	lang.showinraids = "Показать в рейде"
	lang.showinbgs = "Показывать на поле битвы"
		
	lang.healerisdead = "Целитель мертв"
	lang.deathmessage = "Сообщение о смерти"

	lang.neardeath = "При смерти"
	lang.showneardeathchat = "Сообщение в чат при смерти"
	lang.showneardeathemote = "Предсмертная эмоция"

	lang.notinsight = "Не видно"
end
