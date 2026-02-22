--スパーク・ブレイカー
function c120000122.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c120000122.destg)
	e1:SetOperation(c120000122.desop)
	c:RegisterEffect(e1)
end
function c120000122.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000122.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000122.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c120000122.filter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c120000122.gcfilter(c,tc)
	return c:IsType(TYPE_MONSTER) and c:IsCode(tc:GetCode()) and c:IsDestructable()
end
function c120000122.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c120000122.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
		Duel.Destroy(tc,REASON_EFFECT)
		Duel.BreakEffect()
		local gc=Duel.GetMatchingGroup(c120000122.gcfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tc)
		if gc:GetCount()>0 then
			Duel.Destroy(gc,REASON_EFFECT)
	end
end
