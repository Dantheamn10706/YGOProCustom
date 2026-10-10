--クリスタル・アバター
function c120000288.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000288.condition)
	e1:SetTarget(c120000288.target)
	e1:SetOperation(c120000288.activate)
	c:RegisterEffect(e1)
end
function c120000288.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return Duel.GetLP(tp)<=2000 and at and at:GetControler()~=tp and Duel.GetAttackTarget()==nil 
end
function c120000288.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local atk=Duel.GetLP(tp)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,120000288,0,0x21,atk,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000288.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local atk=Duel.GetLP(tp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,120000288,0,0x21,atk,0,4,RACE_WARRIOR,ATTRIBUTE_LIGHT) then return end
	c:AddMonsterAttribute(TYPE_TRAP+TYPE_EFFECT)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000288,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c120000288.damcon)
	e2:SetTarget(c120000288.damtg)
	e2:SetOperation(c120000288.damop)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2,true)
	Duel.SpecialSummonComplete()
	local at=Duel.GetAttacker()
	if at and at:IsAttackable() and at:IsFaceup() and not at:IsImmuneToEffect(e) and not at:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.BreakEffect()
		Duel.ChangeAttackTarget(c)
	end
end
function c120000288.damcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c120000288.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetAttack()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c120000288.damop(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,e:GetHandler():GetAttack(),REASON_EFFECT)
end
