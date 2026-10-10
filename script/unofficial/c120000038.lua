--融爆
function c120000038.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(120000038,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetCondition(c120000038.condition)
	e1:SetOperation(c120000038.activate)
	c:RegisterEffect(e1)
end
function c120000038.cfilter(c,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:GetPreviousControler()==tp and c:IsReason(REASON_EFFECT)
end
function c120000038.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000038.cfilter,1,nil,tp) and re and re:IsActiveType(TYPE_SPELL)
end
function c120000038.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
