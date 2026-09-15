--ジョーズマン
function c120000390.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c120000390.atkup)
	c:RegisterEffect(e1)
end
function c120000390.atkfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c120000390.atkup(e,c)
	return Duel.GetMatchingGroupCount(c120000390.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,c)*300
end
