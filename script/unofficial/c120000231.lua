--機械複製術
function c120000231.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000231.target)
	e1:SetOperation(c120000231.activate)
	c:RegisterEffect(e1)
	--Destroy1
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c120000231.descon)
	e2:SetOperation(c120000231.desop)
	c:RegisterEffect(e2)
	--self destroy1
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EFFECT_SELF_DESTROY)
	e3:SetCondition(c120000231.descon1)
	c:RegisterEffect(e3)
end
function c120000231.filter(c,e,tp)
	return c:IsFaceup() and c:IsAttackBelow(500) and c:IsRace(RACE_MACHINE)
		and Duel.IsExistingMatchingCard(c120000231.filter2,tp,LOCATION_DECK,0,1,nil,c:GetCode(),e,tp)
end
function c120000231.filter2(c,code,e,tp)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000231.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000231.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c120000231.filter,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(63995093,0))
	Duel.SelectTarget(tp,c120000231.filter,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c120000231.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(78800023,RESET_EVENT+0x17a0000,0,0)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		c:SetCardTarget(tc)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c120000231.filter2,tp,LOCATION_DECK,0,1,ft,nil,tc:GetCode(),e,tp)
		local sg=g:GetFirst()
	while sg do
		if Duel.SpecialSummonStep(sg,0,tp,tp,false,false,POS_FACEUP)~=0 then
			--self destroy2
			local e1=Effect.CreateEffect(sg)
			e1:SetCategory(CATEGORY_DESTROY)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e1:SetRange(LOCATION_ONFIELD)
			e1:SetCode(EFFECT_SELF_DESTROY)
			e1:SetCondition(c120000231.descon2)
			e1:SetReset(RESET_EVENT+0x00400000+0x00200000+0x00080000+0x00040000)
			sg:RegisterEffect(e1)	
		end
		sg=g:GetNext()
	end
		Duel.SpecialSummonComplete()
	end
end
function c120000231.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c120000231.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c120000231.descon1(e,tp,eg,ep,ev,re,r,rp)
	local ec=e:GetHandler():GetFirstCardTarget()
	if not ec or ec:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	return ec:GetAttack()>500
end
function c120000231.desfilter(c)
	return c:IsFaceup() and (c:IsCode(120000231) or c:IsCode(63995093)) and c:GetFlagEffect(78800023)~=0
end
function c120000231.descon2(e)
	return not Duel.IsExistingMatchingCard(c120000231.desfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
