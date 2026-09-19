--次元均衡
function c120000061.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000061,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c120000061.condition)
	e1:SetTarget(c120000061.target)
	e1:SetOperation(c120000061.activate)
	c:RegisterEffect(e1)
end
function c120000061.cfilter(c,e,tp)
	return c:IsReason(REASON_BATTLE) and c:GetPreviousControler()==tp and c:IsLocation(LOCATION_GRAVE) and c~=Duel.GetAttacker() 
	and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000061.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000061.cfilter,1,nil,e,tp)
end
function c120000061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local tc=eg:GetFirst()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	 and a:IsCanBeEffectTarget(e) end
	local g=Group.FromCards(a,tc)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,a,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c120000061.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local ex1,tg1=Duel.GetOperationInfo(0,CATEGORY_SPECIAL_SUMMON)
	local ex2,tg2=Duel.GetOperationInfo(0,CATEGORY_REMOVE)
	if tg1:GetFirst():IsRelateToEffect(e) and tg2:GetFirst():IsRelateToEffect(e) then
		Duel.Remove(tg2,POS_FACEUP,REASON_EFFECT)
		Duel.SpecialSummon(tg1,0,tp,tp,false,false,POS_FACEUP)
		Duel.BreakEffect()
		Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
