--光の護封霊剣
function c120000285.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000285,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000285.condition1)
	e1:SetTarget(c120000285.target)
	e1:SetOperation(c120000285.operation1)
	c:RegisterEffect(e1)
	--disable attack
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000285,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c120000285.condition2)
	e2:SetCost(c120000285.cost)
	e2:SetOperation(c120000285.operation1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCondition(c120000285.condition3)
	e3:SetOperation(c120000285.operation2)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_SELF_DESTROY)
	e4:SetCondition(c120000285.descon)
	c:RegisterEffect(e4)
end
function c120000285.condition1(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c120000285.condition2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return Duel.GetLP(tp)>2000 and at and at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c120000285.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
	e:SetLabel(1)
end
function c120000285.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return true end
	e:SetLabel(0)
	if at and at:GetControler()~=tp and Duel.CheckLPCost(tp,1000) and Duel.SelectYesNo(tp,94) then
		Duel.PayLPCost(tp,1000)
		e:SetLabel(1)
		e:GetHandler():RegisterFlagEffect(0,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,65)
	end
end
function c120000285.operation1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 or not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.NegateAttack()
end
function c120000285.condition3(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return Duel.GetLP(tp)<=2000 and at and at:GetControler()~=tp and Duel.GetAttackTarget()==nil
end
function c120000285.operation2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabel()==0 then return end
	Duel.NegateAttack()
end
function c120000285.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=1000
end