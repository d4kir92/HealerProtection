-- koKR Korean
local _, HealerProtection = ...

function HealerProtection:LangkoKR()
	local lang = HealerProtection:GetLangTab()
	lang.aggro = "어그로"
	lang.showaggrochat = "어그로 채팅 메세지"
	lang.showaggroemote = "어그로 이모티"
	lang.outofmana = "마나가 바닥남"
	lang.showoomchat = "마나가 바닥남"
	lang.showoomemote = "마나가 바닥남 이모티"
	lang.nearoutofmana = "마나가 거의 소진됨"
	lang.shownearoomchat = "마나가 거의 소진됨 채팅 메세지"
	lang.shownearoomemote = "마나가 거의 소진됨 이모티"
	lang.youhaveaggro = "어그로 갔습니다"
	lang.ihaveaggro = "어그로 끌렸습니다"
	lang.underhealthprintmessage = "체력이 VALUE% 보다 낮으면 메세지를 보냅니다"
	lang.undermanaprintmessage = "마나가 VALUE% 보다 낮으면 메세지를 보냅니다"
	lang.xmana = "MANA% 마나"
	lang.xhealth = "HEALTH% Gesundheit"
	lang.prefix = "접두사"
	lang.suffix = "접미사"
	lang.printnothing = "출력 안함"
	lang.showinraids = "레이드에서 보기"
	lang.showinbgs = "전장에서 보기"
	lang.healerisdead = "힐러 죽음"
	lang.deathmessage = "죽음 메세지"
	lang.neardeath = "죽기 직전"
	lang.showneardeathchat = "죽기 직전 채팅 메세지"
	lang.showneardeathemote = "죽기 직전 감정표현"
	lang.notinsight = "보이지 않음"
end