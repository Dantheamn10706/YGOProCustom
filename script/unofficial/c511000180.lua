--闇からの奇襲
function c511000180.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000180.condition)
	e1:SetTarget(c511000180.target)
	e1:SetOperation(c511000180.operation)
	c:RegisterEffect(e1)
	if not c511000180.global_check then
		c511000180.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		ge1:SetCode(EVENT_SUMMON_SUCCESS)
		ge1:SetOperation(c511000180.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=ge1:Clone()
		ge2:SetCode(EVENT_SPSUMMON_SUCCESS)
		Duel.RegisterEffect(ge2,0)
		local ge3=ge1:Clone()
		ge3:SetCode(EVENT_SSET)
		Duel.RegisterEffect(ge3,0)
	end
end
function c511000180.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(511000180)==0 then
			tc:RegisterFlagEffect(511000180,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		end
		tc=eg:GetNext()
	end
end
function c511000180.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c511000180.filter(c)
	return c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c511000180.filter2(c,tp,turn)
	return c:GetPreviousControler()==tp and c:GetTurnID()==turn and c:IsType(TYPE_MONSTER) and c:GetPreviousLocation()==LOCATION_MZONE 
end
function c511000180.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c511000180.filter,tp,LOCATION_ONFIELD,0,1,nil)
			or Duel.IsExistingMatchingCard(c511000180.filter2,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,tp,Duel.GetTurnCount()) end 
end
function c511000180.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(c511000180.filter,tp,LOCATION_ONFIELD,0,nil)
	local tc1=g1:GetFirst()
	while tc1 do
		tc1:RegisterFlagEffect(511000180,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		tc1=g1:GetNext()
	end
	--skip phases until Battle Phase
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_EP)
	e2:SetTargetRange(1,0)
	e2:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e3:SetCountLimit(1)
	e3:SetTarget(c511000180.sptg)
	e3:SetOperation(c511000180.spop)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e3,tp)
	--cannot attack
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_ATTACK)
	e4:SetProperty(EFFECT_FLAG_OATH)
	e4:SetTargetRange(LOCATION_MZONE,0)
	e4:SetTarget(c511000180.ftarget)
	e4:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e4,tp)
end
function c511000180.ftarget(e,c)
	return not c:IsStatus(STATUS_SUMMON_TURN+STATUS_SPSUMMON_TURN)
end
function c511000180.skipcon(e)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c511000180.sfilter(c)
	return c:IsType(TYPE_MONSTER) and c:GetFlagEffect(511000180)~=0
end
function c511000180.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsExistingMatchingCard(c511000180.filter,tp,LOCATION_ONFIELD,0,1,nil)
	or Duel.IsExistingMatchingCard(c511000180.sfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_EXTRA,0,1,nil,tp,Duel.GetTurnCount()) end
end
function c511000180.spop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.resetPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	Duel.Hint(HINT_CARD,0,511000180)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(c511000180.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c511000180.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED,0,1,1,nil,e,tp)
		if g:GetCount()~=0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
			
		end
	end
	local sk=Duel.GetTurnPlayer()
	Duel.SkipPhase(sk,PHASE_MAIN2,RESET_PHASE+PHASE_MAIN2,1)
end
