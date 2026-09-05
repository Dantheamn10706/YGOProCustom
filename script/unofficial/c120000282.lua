--ディメンション・スフィンクス
function c120000282.initial_effect(c)
	aux.AddPersistentProcedure(c,0,aux.FilterBoolFunction(Card.IsPosition,POS_FACEUP_ATTACK))
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000282,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_SZONE)
	e1:SetHintTiming(TIMING_DAMAGE_CAL)
	e1:SetTarget(c120000282.damtg)
	e1:SetOperation(c120000282.damop)
	c:RegisterEffect(e1)
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000282,1))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c120000282.descon)
	e2:SetOperation(c120000282.desop)
	c:RegisterEffect(e2)
end
function c120000282.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local at=Duel.GetAttacker()
	local tc=c:GetFirstCardTarget()
	if chk==0 then return tc and Duel.GetAttackTarget()==tc and at:GetAttack()>=tc:GetAttack()*2 and c:GetFlagEffect(120000282)==0 end
	local dam=math.abs(at:GetAttack()-tc:GetAttack())
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
	c:RegisterFlagEffect(120000282,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
end
function c120000282.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=c:GetFirstCardTarget()
	if not tc then return false end
	local at=Duel.GetAttacker()
	if at:IsRelateToBattle() then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		Duel.Damage(p,math.abs(at:GetAttack()-tc:GetAttack()),REASON_EFFECT)
	end
end
function c120000282.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c120000282.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
