--強制召喚
function c511000210.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c511000210.target)
	e1:SetOperation(c511000210.activate)
	c:RegisterEffect(e1)
end
function c511000210.cfilter(c,e,tp)
	return Duel.IsExistingMatchingCard(c511000210.spfilter,tp,0,LOCATION_DECK,1,nil,c:GetRace())
end
function c511000210.spfilter(c,rc)
	return c:IsRace(rc)
end
function c511000210.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511000210.cfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and not Duel.IsPlayerAffectedByEffect(1-tp,59822133)
		and Duel.IsExistingMatchingCard(c511000210.cfilter,1-tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,0,0)
end
function c511000210.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	if ft<=0 or Duel.IsPlayerAffectedByEffect(1-tp,59822133) then return end
	local gt=Duel.SelectMatchingCard(tp,c511000210.cfilter,tp,0,LOCATION_MZONE,1,1,nil,e,tp)
	if gt:GetCount()>0 then
	local rc=gt:GetFirst():GetRace()
	local g=Duel.GetMatchingGroup(c511000210.spfilter,tp,0,LOCATION_DECK,nil,rc)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
	local sg=g:Select(1-tp,ft,ft,nil)
	local tc=sg:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)~=0 then
		tc:RegisterFlagEffect(511000210,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		tc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
		sg:KeepAlive()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAINING)
		e1:SetLabelObject(sg)
		e1:SetCondition(c511000210.discon)
		e1:SetOperation(c511000210.disop)
		Duel.RegisterEffect(e1,tp)
		end
	end
end	
function c511000210.disfilter(c)
	return c:GetFlagEffect(511000210)>0
end
function c511000210.discon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	if not g:IsExists(c511000210.disfilter,1,nil) then
		g:DeleteGroup()
		e:Reset()
		return false
	end
	return g:IsContains(re:GetHandler()) and re:GetCode()==EVENT_SPSUMMON_SUCCESS and Duel.IsChainDisablable(ev)
end
function c511000210.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateEffect(ev)
end