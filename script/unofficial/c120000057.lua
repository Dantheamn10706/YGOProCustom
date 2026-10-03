--チェーン・クローズ
function c120000057.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCondition(c120000057.condition)
	e1:SetTarget(c120000057.target)
	e1:SetOperation(c120000057.operation)
	c:RegisterEffect(e1)
end
function c120000057.cfilter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function c120000057.condition(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(r,REASON_DESTROY)~=0 and eg:IsExists(c120000057.cfilter,1,nil)
end
function c120000057.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(c120000057.chainlimit)
end
function c120000057.chainlimit(e,rp,tp)
	return not e:IsHasType(EFFECT_TYPE_ACTIVATE)
end
function c120000057.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c120000057.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c120000057.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e) and re:IsHasType(EFFECT_TYPE_ACTIVATE)
end
