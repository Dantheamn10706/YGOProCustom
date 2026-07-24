--黒猫の睨み
function c120000375.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000375.condition)
	e1:SetOperation(c120000375.activate)
	c:RegisterEffect(e1)
end
function c120000375.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFacedown() and c:IsDefensePos()
end
function c120000375.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetMatchingGroupCount(c120000375.cfilter,tp,LOCATION_ONFIELD,0,nil)>=2
end
function c120000375.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end