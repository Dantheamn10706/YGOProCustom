--バトル・リターン
function c120000056.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000056,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(c120000056.condition)
	e1:SetOperation(c120000056.operation)
	c:RegisterEffect(e1)
	--Attack disabled
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetDescription(aux.Stringid(120000056,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_ATTACK_DISABLED)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCondition(c120000056.condition1)
	e2:SetTarget(c120000056.target)
	e2:SetOperation(c120000056.operation1)
	c:RegisterEffect(e2)
end
function c120000056.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	return a and a:IsControler(tp) and at and at:IsRelateToBattle() and not at:IsStatus(STATUS_BATTLE_DESTROYED) and a:IsOnField() and a:IsRelateToBattle() 
end
function c120000056.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(a:GetAttack()/2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	a:RegisterEffect(e1)
	Duel.ChainAttack()
	end
end
function c120000056.condition1(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:IsFaceup() and a:IsControler(tp) and a:IsOnField() and a:IsRelateToBattle()
end
function c120000056.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc==eg:GetFirst() end
	if chk==0 then return eg:GetFirst():IsFaceup() and eg:GetFirst():IsCanBeEffectTarget(e) and eg:GetFirst():IsControler(tp) end
	Duel.SetTargetCard(eg:GetFirst())
end
function c120000056.operation1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:GetFlagEffect(94770493)==0 then
	Duel.ChainAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(tc:GetAttack()/2)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK)
	e2:SetValue(1)
	e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e2)
	end
end	
