--ザ・マテリアル・ロード
function c120000216.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c120000216.condition)
	c:RegisterEffect(e1)
end
function c120000216.cfilter(c)
	return c:IsLevelBelow(4) and c:IsSetCard(0x5)
end
function c120000216.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000216.cfilter,tp,LOCATION_GRAVE,0,1,nil)
end