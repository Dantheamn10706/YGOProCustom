--リフレクト・バウンダー
function c511020012.initial_effect(c)
	--reflect 1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(2851070,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c511020012.damcon1)
	e1:SetTarget(c511020012.damtg1)
	e1:SetOperation(c511020012.damop1)
	c:RegisterEffect(e1)
	--reflect 2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2851070,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e2:SetCondition(c511020012.damcon2)
	e2:SetTarget(c511020012.damtg2)
	e2:SetOperation(c511020012.damop2)
	c:RegisterEffect(e2)
	--seldestroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(2851070,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetTarget(c511020012.destg)
	e3:SetOperation(c511020012.desop)
	c:RegisterEffect(e3)
end
function c511020012.damcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget()
	local d=Duel.GetAttacker()
	return c==e:GetHandler() and c:GetBattlePosition()==POS_FACEUP_ATTACK and e:GetHandler():GetFlagEffect(120000060)==0
	and d:IsControler(1-tp)
end
function c511020012.damtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then	return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c511020012.damop1(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local lp1=Duel.GetLP(p)
	Duel.Damage(p,Duel.GetAttacker():GetAttack(),REASON_EFFECT)
	local lp2=Duel.GetLP(p)
	if lp2<lp1 then
		e:GetHandler():RegisterFlagEffect(120000060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c511020012.damcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=Duel.GetAttackTarget() 
	local d=Duel.GetAttacker()
	return c==e:GetHandler() and c:GetBattlePosition()==POS_FACEUP_ATTACK and d:IsControler(tp) and e:GetHandler():GetFlagEffect(120000060)==0
end
function c511020012.damtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk ==0 then	return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,0)
end
function c511020012.damop2(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local lp1=Duel.GetLP(p)
	Duel.Damage(p,Duel.GetAttacker():GetAttack(),REASON_EFFECT)
	local lp2=Duel.GetLP(p)
	if lp2<lp1 then
		e:GetHandler():RegisterFlagEffect(120000060,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE,0,1)
	end
end
function c511020012.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFlagEffect(120000060)~=0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function c511020012.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end