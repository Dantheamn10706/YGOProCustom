--ＴＧ ギア・ゾンビ ZO-06
function c120000127.initial_effect(c)
	--Special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetDescription(aux.Stringid(120000127,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000127.spcon)
	e1:SetOperation(c120000127.spop)
	c:RegisterEffect(e1)
	--Type Machine
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_ADD_RACE)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetValue(RACE_MACHINE)
	c:RegisterEffect(e2)
	--Half stats
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000127,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c120000127.discon)
	e3:SetOperation(c120000127.disop)
	c:RegisterEffect(e3)
end
function c120000127.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsRace(RACE_MACHINE) and c:GetAttack()>0
end
function c120000127.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000127.spfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c120000127.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c120000127.spfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	if tc then
	local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
	if tc and tc:RegisterEffect(e1) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end	
end
function c120000127.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if rp~=tp or not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsContains(c) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP) and c:IsRace(RACE_MACHINE) and (re:GetHandler():IsCode(63995093) 
	or re:GetHandler():IsCode(12503902) or re:GetHandler():IsCode(63851864) or re:GetHandler():IsCode(42237854) or re:GetHandler():IsCode(63995093)
	or re:GetHandler():IsCode(7030340) or re:GetHandler():IsCode(35220244) or re:GetHandler():IsCode(511600009) or re:GetHandler():IsCode(511002887)
	or re:GetHandler():IsCode(511002568) or re:GetHandler():IsCode(511001883) or re:GetHandler():IsCode(511002308) or re:GetHandler():IsCode(511001762))
	--This list must continue to be updated
end
function c120000127.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(c:GetBaseAttack()/2)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(c:GetBaseDefense()/2)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
	end
end