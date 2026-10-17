--ドゥーブルパッセ
function c120000230.initial_effect(c)
	--change battle target
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000230,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000230.cbcon)
	e1:SetTarget(c120000230.cbtg)
	e1:SetOperation(c120000230.cbop)
	c:RegisterEffect(e1)
end
function c120000230.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsPosition(POS_FACEUP_ATTACK) and d:IsControler(e:GetHandler():GetControler())
end
function c120000230.cbtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.GetAttacker():IsHasEffect(EFFECT_CANNOT_DIRECT_ATTACK) end
end
function c120000230.cbop(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	local bt=Duel.GetAttackTarget()
	if not (bt:IsRelateToBattle() and bt:IsControler(tp)) then return end
	if at and at:IsAttackable() and not at:IsStatus(STATUS_ATTACK_CANCELED) and Duel.ChangeAttackTarget(nil) then
		Duel.BreakEffect()
		Duel.Damage(1-tp,bt:GetAttack(),REASON_BATTLE+REASON_EFFECT)
		Duel.RaiseSingleEvent(bt,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE+REASON_EFFECT,1-tp,1-tp,bt:GetAttack())	
	end
end
