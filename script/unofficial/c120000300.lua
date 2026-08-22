--ロケット戦士
function c120000300.initial_effect(c)
	--invincible Mode
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000300,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c120000300.racon)
	e1:SetOperation(c120000300.raop)
	c:RegisterEffect(e1)
end
function c120000300.racon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and Duel.GetAttackTarget()
end
function c120000300.raop(e,tp,eg,ep,ev,re,r,rp)
	local atk=e:GetHandler():GetAttack()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e:GetHandler():RegisterEffect(e2)
	local d=Duel.GetAttackTarget()
	if not d:IsRelateToBattle() or d:IsFacedown() then return end
		--atk
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(-atk)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		d:RegisterEffect(e3)
end