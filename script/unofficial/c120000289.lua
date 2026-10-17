--竜の闘志
function c120000289.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000289.target)
	e1:SetOperation(c120000289.activate)
	c:RegisterEffect(e1)
	if not c120000289.global_check then
		c120000289.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SPSUMMON_SUCCESS)
		ge1:SetOperation(c120000289.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c120000289.cfilter(c,tp)
	return c:IsControler(tp)
end
function c120000289.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ct=eg:FilterCount(c120000289.cfilter,nil,1-tp)
	if ct<=0 then return end
	for i=1,ct do
		Duel.RegisterFlagEffect(tp,120000289,RESET_PHASE+PHASE_END,0,1)
	end
end
function c120000289.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_DRAGON) and c:GetFlagEffect(120000289)==0 and c:IsStatus(STATUS_SPSUMMON_TURN)
end
function c120000289.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.GetFlagEffect(tp,120000289)>0 and Duel.IsExistingMatchingCard(c120000289.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c120000289.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,c120000289.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_ATTACK)
		e1:SetValue(Duel.GetFlagEffect(tp,120000289))
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(120000289,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
