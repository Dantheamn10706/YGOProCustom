--蜃気楼の筒
function c511004132.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetCondition(c511004132.condition)
	e1:SetTarget(c511004132.target)
	e1:SetOperation(c511004132.activate)
	c:RegisterEffect(e1)
end
function c511004132.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst():IsControler(tp) and eg:GetFirst():IsFaceup()
end
function c511004132.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	a=Duel.GetAttackTarget()
	Duel.SetTargetCard(a)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,a:GetAttack())
end
function c511004132.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttackTarget()
	local dam=tc:GetAttack()
	if tc and tc:IsRelateToEffect(e) then
		Duel.NegateAttack()
		Duel.Damage(1-tp,dam,REASON_EFFECT)
	end
end
