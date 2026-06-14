--オーディンの眼
function c120000256.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000256.condition1)
	e1:SetTarget(c120000256.target)
	e1:SetOperation(c120000256.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(c120000256.condition2)
	e2:SetTarget(c120000256.target)
	e2:SetOperation(c120000256.operation)
	c:RegisterEffect(e2)
end
function c120000256.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DEVINE)
end
function c120000256.condition1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c120000256.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000256.condition2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000256.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000256.filter2(c)
	return c:IsFaceup() and c:IsRace(RACE_DEVINE) and not c:IsDisabled()
end
function c120000256.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c120000256.filter2(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c120000256.filter2,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.GetMatchingGroup(c120000256.filter2,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c120000256.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000256.filter2,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		if not tc:IsImmuneToEffect(e1) and not tc:IsImmuneToEffect(e2) then
			op=Duel.SelectOption(tp,aux.Stringid(120000256,0),aux.Stringid(120000256,1))
			tc=g:GetNext()
		end
			if op==0 then
				local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
				Duel.ConfirmCards(tp,g1)	
				Duel.ShuffleHand(1-tp)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEDOWN)
				local g2=Duel.SelectMatchingCard(tp,Card.IsFacedown,tp,0,LOCATION_ONFIELD,1,1,nil):GetFirst()
				Duel.ConfirmCards(tp,g2)
		end		
	end			
end