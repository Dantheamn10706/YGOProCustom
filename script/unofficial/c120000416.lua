--クロクロークロウ
function c120000416.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000416.spcon)
	c:RegisterEffect(e1)
end
function c120000416.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c120000416.spcon(e,c)
	if c==nil then return true end
	local ct=Duel.GetMatchingGroupCount(c120000416.filter,tp,LOCATION_ONFIELD,0,nil)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>0
end
