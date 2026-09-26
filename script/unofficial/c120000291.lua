--ギミック・パペット－ボム・エッグ
function c120000291.initial_effect(c)
	--effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000291,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetTarget(c120000291.damtg)
	e1:SetOperation(c120000291.damop)
	c:RegisterEffect(e1)
end
function c120000291.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_MONSTER) and 
		Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,nil) end
	local cg=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(cg,REASON_COST)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000291.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
