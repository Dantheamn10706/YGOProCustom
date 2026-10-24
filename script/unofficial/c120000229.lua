--ナチュラル・ディザスター
function c120000229.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000229,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c120000229.condition)
	e2:SetOperation(c120000229.operation)
	c:RegisterEffect(e2)
end
function c120000229.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsReason(REASON_DESTROY)
end
function c120000229.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000229.cfilter,1,nil,1-tp)
end
function c120000229.operation(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c120000229.cfilter,nil,1-tp)
	Duel.Damage(1-tp,ct*400,REASON_EFFECT)
end
