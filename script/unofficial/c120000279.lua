--ディメンション・ミラージュ
function c120000279.initial_effect(c)
	aux.AddPersistentProcedure(c,1,aux.FilterBoolFunction(Card.IsPosition,POS_FACEUP_ATTACK))
	--multi attack 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000279,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c120000279.atcon1)
	e1:SetCost(c120000279.atcost)
	e1:SetTarget(c120000279.attg1)
	e1:SetOperation(c120000279.atop1)
	c:RegisterEffect(e1)
	--multi attack 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000279,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c120000279.atcon2)
	e2:SetCost(c120000279.atcost)
	e2:SetOperation(c120000279.atop2)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCondition(c120000279.descon)
	e3:SetOperation(c120000279.desop)
	c:RegisterEffect(e3)
end
function c120000279.atcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local at=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if e:GetHandler():GetFlagEffect(120000279)~=0 then return false end
	return at and at:IsOnField() and at:IsControler(1-tp) and at==tc and at:IsChainAttackable(0) and d and d:IsOnField() and d:IsRelateToBattle() and not d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c120000279.costfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c120000279.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=Duel.GetAttacker()
	if chk==0 then return Duel.IsExistingMatchingCard(c120000279.costfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c120000279.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	e:GetHandler():RegisterFlagEffect(120000279,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	at:RegisterFlagEffect(120000279,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE,0,1)
end
function c120000279.attg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local at=e:GetHandler():GetFirstCardTarget()
	if at:IsControler(1-tp) then at=Duel.GetAttacker() end
	if chk==0 then return true end
	Duel.SetTargetCard(at)
end
function c120000279.atop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetFirstCardTarget()
	if tc:IsRelateToBattle() and tc:IsAttackable() and not tc:IsStatus(STATUS_ATTACK_CANCELED) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_MUST_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_FIRST_ATTACK)
		tc:RegisterEffect(e2)
		Duel.ChainAttack()
	end
end
function c120000279.atcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=c:GetFirstCardTarget()
	local at=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if e:GetHandler():GetFlagEffect(120000279)~=0 then return false end
	return at and at:IsOnField() and at:IsControler(tp) and d and d==tc and d:IsOnField() and d:IsRelateToBattle() and not d:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c120000279.atop2(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker() 
	local tc=e:GetHandler():GetFirstCardTarget()
	--multi attack 3
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(120000279,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c120000279.atcost)
	e1:SetOperation(c120000279.atop3)
	e1:SetReset(RESET_PHASE+PHASE_BATTLE)
	Duel.RegisterEffect(e1,tp)
	if at and at:IsRelateToBattle() and at:IsAttackable() and not at:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.CalculateDamage(tc,at)
	end
end
function c120000279.gfilter(c)
	return c:GetFlagEffect(120000279)~=0
end
function c120000279.atop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	local g=Duel.SelectMatchingCard(tp,c120000279.gfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 and tc then
		Duel.CalculateDamage(tc,g:GetFirst())
	end
end
function c120000279.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c120000279.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
