--Emハットトリッカー
function c120000380.initial_effect(c)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000380.spcon)
	c:RegisterEffect(e1)
end
function c120000380.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000380.spcon(e,c)
	if c==nil then return true end
	local ct=Duel.GetMatchingGroupCount(c120000380.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return ct==2
end