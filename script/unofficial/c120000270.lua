--バスター・ブレイダー
function c120000270.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c120000270.val)
	c:RegisterEffect(e1)
end
function c120000270.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_DRAGON)
end
function c120000270.val(e,c)
	return Duel.GetMatchingGroupCount(c120000270.filter,c:GetControler(),LOCATION_ONFIELD,LOCATION_ONFIELD,nil)*500
end
