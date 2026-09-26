--針剣士
function c120000252.initial_effect(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000252,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetCondition(c120000252.condition)
	e1:SetTarget(c120000252.target)
	e1:SetOperation(c120000252.operation)
	c:RegisterEffect(e1)
end
function c120000252.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil and Duel.GetAttacker()==e:GetHandler()
end
function c120000252.filter(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c120000252.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c120000252.filter,tp,0,LOCATION_SZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c120000252.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000252.filter,tp,0,LOCATION_SZONE,nil)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
