--運命湾曲
function c120000382.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c120000382.condition1)
	e1:SetTarget(c120000382.target1)
	e1:SetOperation(c120000382.activate1)
	c:RegisterEffect(e1)
	--Activate(effect)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_NEGATE+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c120000382.condition2)
	e2:SetTarget(c120000382.target2)
	e2:SetOperation(c120000382.activate2)
	c:RegisterEffect(e2)
end
function c120000382.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x31)
end
function c120000382.check(tp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_ONFIELD,0,nil)
	return g:IsExists(c120000382.cfilter,1,nil)
		and not g:IsExists(aux.NOT(c120000382.cfilter),1,nil)
end
function c120000382.condition1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and c120000382.check(tp)
end
function c120000382.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,eg,1,0,0)
end
function c120000382.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateSummon(eg:GetFirst())
	Duel.SendtoHand(eg,nil,REASON_EFFECT)
	--forbidden
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e1:SetCode(EFFECT_FORBIDDEN)
	e1:SetTargetRange(0x7f,0x7f)
	e1:SetLabelObject(eg:GetFirst())
	e1:SetTarget(c120000382.bantg)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c120000382.bantg(e,c)
	return e:GetLabelObject()==c
end
function c120000382.condition2(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.IsChainNegatable(ev) and c120000382.check(tp)
end
function c120000382.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:GetFirst():IsAbleToRemove() end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,eg,1,0,0)
	end
end
function c120000382.activate2(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		ec:CancelToGrave()
		Duel.SendtoHand(ec,nil,REASON_EFFECT)
		--forbidden
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTargetRange(0x7f,0x7f)
		e1:SetLabelObject(ec)
		e1:SetTarget(c120000382.bantg)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
	end
end
