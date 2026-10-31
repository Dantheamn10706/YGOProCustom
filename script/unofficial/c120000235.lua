--万華鏡－華麗なる分身－
function c120000235.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000235.condition)
	e1:SetTarget(c120000235.target)
	e1:SetOperation(c120000235.activate)
	c:RegisterEffect(e1)
end
function c120000235.filter(c)
	return c:IsFaceup() and c:IsCode(76812113)
end
function c120000235.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000235.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c120000235.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c120000235.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c120000235.filter,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,2,0,0)
end
function c120000235.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.SelectMatchingCard(tp,c120000235.filter,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp):GetFirst()
	local tpe=tc:GetType()
	local atk=tc:GetAttack()
	local def=tc:GetDefense()
	local Lv=tc:GetLevel()
	local rc=tc:GetRace()
	local at=tc:GetAttribute()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummonMonster(tp,tc:GetOriginalCode(),0,tc:GetOriginalType(),tc:GetTextAttack(),tc:GetTextDefense(),
		tc:GetOriginalLevel(),tc:GetOriginalRace(),tc:GetOriginalAttribute()) then return end	
	for i=1,2 do	
		local token=Duel.CreateToken(tp,tc:GetOriginalCode())
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(tpe)
		e1:SetReset(RESET_EVENT+0xfe0000)
		token:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_ATTACK_FINAL)
		e2:SetValue(atk)
		token:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e3:SetValue(def)
		token:RegisterEffect(e3)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_CHANGE_LEVEL)
		e4:SetValue(tc:GetLevel())
		token:RegisterEffect(e4)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_ADD_RACE)
		e5:SetValue(rc)
		token:RegisterEffect(e5)
		local e6=e1:Clone()
		e6:SetCode(EFFECT_ADD_ATTRIBUTE)
		e6:SetValue(at)
		token:RegisterEffect(e6)
		local e7=e1:Clone()
		e7:SetCode(EFFECT_CANNOT_ATTACK)
		e7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		token:RegisterEffect(e7)
		local e8=e1:Clone()
		e8:SetCode(EFFECT_CANNOT_ATTACK)
		e8:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e8)
	end
		Duel.SpecialSummonComplete()
end
