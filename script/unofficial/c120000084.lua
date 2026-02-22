--魔界パフォーマンス
function c120000084.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000084,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c120000084.condition)
	e1:SetTarget(c120000084.target)
	e1:SetOperation(c120000084.activate)
	c:RegisterEffect(e1)
end
function c120000084.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return eg:GetCount()==1 and tc:IsControler(tp) and tc:IsSetCard(0x10ec) and bc:IsReason(REASON_BATTLE)
end
function c120000084.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=eg:GetFirst()
	if chk==0 then return tg:IsOnField() end
	Duel.SetTargetCard(tg)
end
function c120000084.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	local atk=tc:GetAttack()/2
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	if tc:RegisterEffect(e1) then
	Duel.ChainAttack()
	end
end
