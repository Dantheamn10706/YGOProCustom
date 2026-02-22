--ガーディアン・フォース
function c511000284.initial_effect(c)
	--Negate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(9837195,0))
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c511000284.condition)
	e1:SetTarget(c511000284.target)
	e1:SetOperation(c511000284.activate)
	c:RegisterEffect(e1)
end
function c511000284.filter(c)
	return c:IsSetCard(0x52)
end
function c511000284.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(c511000284.filter,tp,LOCATION_GRAVE,0,1,nil) then return end
	return re:IsActiveType(TYPE_SPELL) and rp~=tp and Duel.IsChainNegatable(ev)
end
function c511000284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c511000284.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
