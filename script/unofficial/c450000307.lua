--グランエルＴ 
function c450000307.initial_effect(c)
	--self destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c450000307.sdcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(450000307,0))
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCondition(c450000307.condition)
	e2:SetTarget(c450000307.target)
	e2:SetOperation(c450000307.operation)
	c:RegisterEffect(e2)
end
function c450000307.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x3013)
end
function c450000307.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_MONSTER) and not Duel.IsExistingMatchingCard(c450000307.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and not c:IsCode(63468625)
end
function c450000307.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return e:GetHandler():IsType(TYPE_MONSTER) and at:IsControler(tp) and (at:IsSetCard(0x3013) or at:IsCode(63468625))
end
function c450000307.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and not c:IsDisabled()
end
function c450000307.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsLocation(LOCATION_MZONE) and c450000307.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c450000307.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c450000307.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c450000307.filter,tp,0,LOCATION_ONFIELD,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc:RegisterEffect(e2)
		if tc:IsType(TYPE_TRAPMONSTER) then
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_TRAPMONSTER)
			e3:SetReset(RESET_PHASE+PHASE_DAMAGE)
			tc:RegisterEffect(e3)
		end
		tc=g:GetNext()
	end
end
