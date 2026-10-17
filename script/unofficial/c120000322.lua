--ラプターズ・ガスト
function c120000322.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCondition(c120000322.condition)
	e1:SetTarget(c120000322.target)
	e1:SetOperation(c120000322.activate)
	c:RegisterEffect(e1)
end
function c120000322.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba)
end
function c120000322.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and re:IsActiveType(TYPE_SPELL) and Duel.IsChainNegatable(ev)
		and Duel.IsExistingMatchingCard(c120000322.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000322.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,re:GetHandler(),1,0,0)
	end
end
function c120000322.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end
end
