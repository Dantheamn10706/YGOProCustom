--時の女神の悪戯
function c511001133.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c511001133.activate)
	c:RegisterEffect(e1)
	if not c511001133.global_check then
		c511001133.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_SSET)
		ge1:SetOperation(c511001133.checkop1)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511001133.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:GetFlagEffect(511001133)==0 then
			tc:RegisterFlagEffect(511001133,RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
		end
		tc=eg:GetNext()
	end
end
function c511001133.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local tid=Duel.GetTurnCount()
	local p=Duel.GetTurnPlayer()
	if p==tp then
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_SKIP_TURN)
		e1:SetTargetRange(0,1)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		Duel.RegisterEffect(e1,tp)
		--spirit do not return
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_SPIRIT_DONOT_RETURN)
		e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		if p==tp then
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,3)
		else
			e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,2)
		end
		Duel.RegisterEffect(e2,tp)
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	else
		Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
		Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	end
	Duel.SkipPhase(p,PHASE_DRAW,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_STANDBY,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(p,PHASE_MAIN1,RESET_PHASE+PHASE_END,1)
	if ph<PHASE_BATTLE_START then
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetCode(EFFECT_CANNOT_BP)
		e3:SetTargetRange(1,1)
		e3:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,p)
	else
		Duel.SkipPhase(p,PHASE_BATTLE,RESET_PHASE+PHASE_END,1,2)
	end
	Duel.SkipPhase(p,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	local e4=Effect.GlobalEffect()
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetTargetRange(1,1)
	if p==tp then
		e4:SetReset(RESET_PHASE+PHASE_END,3)
	else
		e4:SetReset(RESET_PHASE+PHASE_END,2)
	end
	Duel.RegisterEffect(e4,tp)
	--status summon
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e5:SetCountLimit(1)
	e5:SetOperation(c511001133.sptop)
	if p==tp then
		e5:SetReset(RESET_PHASE+PHASE_END,3)
	else
		e5:SetReset(RESET_PHASE+PHASE_END,2)
	end
	Duel.RegisterEffect(e5,tp)
	--cannot trigger
	local e6=Effect.GlobalEffect()
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_ADJUST)
	e6:SetOperation(c511001133.actop)
	if p==tp then
		e6:SetReset(RESET_PHASE+PHASE_END,3)
	else
		e6:SetReset(RESET_PHASE+PHASE_END,2)
	end
	Duel.RegisterEffect(e6,tp)
end
function c511001133.sptfilter(c,tp,turn)
	return c:IsType(TYPE_SPIRIT) and c:GetTurnID()==turn-2
end
function c511001133.sptop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(c511001133.sptfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,tp,Duel.GetTurnCount())
	local tc1=g1:GetFirst()
	if tc1 then
		tc1:SetStatus(STATUS_SUMMON_TURN,true)
		tc1=g1:GetNext()
	end
end
function c511001133.tfilter(c,tp,turn)
	return c:IsFacedown() and c:GetTurnID()==turn-2 and c:GetFlagEffect(511001133)~=0
end
function c511001133.actop(e,tp,eg,ep,ev,re,r,rp)
	local g2=Duel.GetMatchingGroup(c511001133.tfilter,tp,LOCATION_SZONE,LOCATION_SZONE,nil,tp,Duel.GetTurnCount())
	local tc2=g2:GetFirst()
	if tc2 then
		tc2:SetStatus(STATUS_SET_TURN,true)
		tc2=g2:GetNext()
	end
end
