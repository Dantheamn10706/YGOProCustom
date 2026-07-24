--Reaper Scythe - Dreadscythe (Anime)
--Anime version: gains 500 ATK per monster in YOUR Graveyard (only, not both GYs).
local s,id=GetID()
function s.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsCode,18175965))
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.value)
	c:RegisterEffect(e1)
end
s.listed_names={18175965}
function s.value(e,c)
	local tp=e:GetHandler():GetControler()
	return Duel.GetMatchingGroupCount(Card.IsMonster,tp,LOCATION_GRAVE,0,nil)*500
end
