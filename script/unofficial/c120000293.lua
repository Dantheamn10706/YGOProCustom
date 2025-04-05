--太陽風帆船
function c120000293.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000293.spcon)
	e1:SetOperation(c120000293.spop)
	c:RegisterEffect(e1)
end
function c120000293.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000293.spcon(e,c)
	if c==nil then return true end
	local ct=Duel.GetMatchingGroupCount(c120000293.cfilter,tp,LOCATION_ONFIELD,0,nil)
	return ct==0
end
function c120000293.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local atk=c:GetBaseAttack()
	local def=c:GetBaseDefense()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(atk/2)
	e1:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(def/2)
	c:RegisterEffect(e2)
end
