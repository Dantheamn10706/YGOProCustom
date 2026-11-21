--バウンサー・ガード
function c120000384.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000384.condition)
	e1:SetTarget(c120000384.target)
	e1:SetOperation(c120000384.activate)
	c:RegisterEffect(e1)
end
function c120000384.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:GetControler()==1-tp  
end
function c120000384.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x6b)
end
function c120000384.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttackTarget()
	if chk==0 then
		if at then
			return Duel.IsExistingMatchingCard(c120000384.filter,tp,LOCATION_ONFIELD,0,1,at) 
		else
			return Duel.IsExistingMatchingCard(c120000384.filter,tp,LOCATION_ONFIELD,0,1,nil) 
		end
	end
end
function c120000384.activate(e,tp,eg,ep,ev,re,r,rp)
	local g
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	if Duel.GetAttackTarget() then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=Duel.SelectMatchingCard(tp,c120000384.filter,tp,LOCATION_ONFIELD,0,1,1,Duel.GetAttackTarget())
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		g=Duel.SelectMatchingCard(tp,c120000384.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	end
	if g:GetCount()>0 then
		Duel.ChangeAttackTarget(g:GetFirst())
	end	
end
		