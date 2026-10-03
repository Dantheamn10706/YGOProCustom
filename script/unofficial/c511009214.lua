--メタル・リフレクト・スライム
function c511009214.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DAMAGE)
	e1:SetCondition(c511009214.condition)
	e1:SetTarget(c511009214.target)
	e1:SetOperation(c511009214.activate)
	c:RegisterEffect(e1)
end
function c511009214.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and ev>=Duel.GetLP(tp)+ev/2
end
function c511009214.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,26905245,0,0x21,0,-2,-2,-2,RACE_AQUA,ATTRIBUTE_WATER) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c511009214.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,c,26905245,0,0x21,0,0x21,0,-2,-2,-2,RACE_AQUA,ATTRIBUTE_WATER) then return end
	c:AddMonsterAttribute(TYPE_MONSTER)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_RACE)
	e1:SetValue(Duel.GetAttacker():GetRace())
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	e2:SetValue(Duel.GetAttacker():GetAttribute())
	c:RegisterEffect(e2,true)
	local e3=e1:Clone()
	e3:SetCode(EFFECT_CHANGE_LEVEL)
	e3:SetValue(Duel.GetAttacker():GetLevel())
	c:RegisterEffect(e3,true)
	local e4=e1:Clone()
	e4:SetCode(EFFECT_SET_DEFENSE)
	e4:SetValue(Duel.GetAttacker():GetAttack()*3/4)
	c:RegisterEffect(e4,true)
	--cannot attack
	local e5=e1:Clone()
	e5:SetCode(EFFECT_CANNOT_ATTACK)
	c:RegisterEffect(e5,true)
	Duel.SpecialSummonComplete()
end
