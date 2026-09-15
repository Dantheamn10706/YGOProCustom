--Pendulum from Extra Deck (Rule)
--Lifts the MR2020 zone restriction on ED Pendulum Summons by adding all
--Main Monster Zones to the linked-zone pool. Under MR2020, Synchro/Xyz/Fusion
--summons take the DUEL_FSX_MMZONE branch in field::get_rule_zone_fromex and
--receive 0x7f directly; only face-up ED Pendulum candidates fall through to
--the get_linked_zone() | EMZ branch, so this effect cleanly targets only them.
local s,id=GetID()
function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.init)
end
function s.init(c)
	for p=0,1 do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_BECOME_LINKED_ZONE)
		e1:SetValue(0xffffff)
		Duel.RegisterEffect(e1,p)
	end
end
