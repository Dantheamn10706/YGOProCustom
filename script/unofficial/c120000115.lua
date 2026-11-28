--ツイン・ボルテックス
function c120000115.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000115,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(c120000115.condition)
	e1:SetTarget(c120000115.target)
	e1:SetOperation(c120000115.operation)
	c:RegisterEffect(e1)
end
function c120000115.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return (a and a:IsControler(1-tp))
end
function c120000115.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000115.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingMatchingCard(c120000115.desfilter,tp,LOCATION_ONFIELD,0,1,nil) 
		and Duel.IsExistingMatchingCard(c120000115.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c120000115.operation(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.SelectMatchingCard(tp,c120000115.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local g2=Duel.SelectMatchingCard(tp,c120000115.desfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	g1:Merge(g2)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end	
end
