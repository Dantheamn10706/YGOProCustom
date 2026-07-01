--エクシーズ・ブロック
function c120000090.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c120000090.condition)
	e1:SetCost(c120000090.cost)
	e1:SetTarget(c120000090.target)
	e1:SetOperation(c120000090.activate)
	c:RegisterEffect(e1)
end
function c120000090.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.IsChainNegatable(ev)
end
function c120000090.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0 and c:CheckRemoveOverlayCard(tp,1,REASON_COST)
end
function c120000090.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end
function c120000090.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function c120000090.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end
