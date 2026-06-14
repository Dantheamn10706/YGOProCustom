--先史遺産 モアイキャリア
function c120000152.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000152.spcon)
	c:RegisterEffect(e1)
end
function c120000152.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000152.spcon(e,c)
	if c==nil then return true end
	local ct1=Duel.GetMatchingGroupCount(c120000152.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c120000152.cfilter,tp,0,LOCATION_ONFIELD,nil)
	return ct1==0 and ct2>0
end
