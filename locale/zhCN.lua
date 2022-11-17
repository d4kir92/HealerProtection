-- zhCN Simplified Chinese

local AddOnName, HealerProtection = ...

function HealerProtection:LangzhCN()
	local lang = HealerProtection:GetLangTab()

	lang.aggro = "仇恨"
	lang.showaggrochat = "仇恨 聊天消息"
	lang.showaggroemote = "仇恨 表情"

	lang.outofmana = "没蓝了"
	lang.showoomchat = "没蓝 聊天消息"
	lang.showoomemote = "没蓝 表情"

	lang.nearoutofmana = "我快没蓝了"
	lang.shownearoomchat = "快没蓝 聊天消息"
	lang.shownearoomemote = "快没蓝 表情"

	lang.youhaveaggro = "你被怪盯上啦"
	lang.ihaveaggro = "我被怪盯上啦"

	lang.underhealthprintmessage = "如果低于 VALUE% 生命值，发送聊天消息"
	lang.undermanaprintmessage = "如果低于 VALUE% 法力值，发送聊天消息"

	lang.xmana = "MANA% 法力值"

	lang.prefix = "前缀"
	lang.suffix = "后缀"

	lang.printnothing = "不显示任何东西"
	lang.showinraids = "在团队时显示"
	lang.showinbgs = "在战场时显示"

	lang.healerisdead = "治疗死了"
	lang.deathmessage = "死亡信息"
end
