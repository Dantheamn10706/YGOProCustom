--奇跡の銀河
function c511005078.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(23118924,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511005078.condition)
	e1:SetOperation(c511005078.operation)
	c:RegisterEffect(e1)
	if not c511005078.global_check then
		c511005078.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLE_DAMAGE)
		ge1:SetOperation(c511005078.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511005078.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and Duel.GetTurnPlayer()==tp then
		Duel.RegisterFlagEffect(ep,511005078,RESET_PHASE+PHASE_END,0,1)
	end
end
function c511005078.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFlagEffect(tp,511005078)==0 and Duel.GetCurrentPhase()==PHASE_MAIN2
end
function c511005078.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetCondition(c511005078.atkcon)
	e1:SetTarget(c511005078.atktg)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
	--check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetOperation(c511005078.checkop)
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e2,tp)
	--skip phases until Battle Phase
	Duel.SkipPhase(tp,PHASE_BATTLE,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_MAIN2,RESET_PHASE+PHASE_END,1)
	Duel.SkipPhase(tp,PHASE_END,RESET_PHASE+PHASE_END,1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_SKIP_TURN)
	e3:SetTargetRange(0,1)
	e3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e3,tp)
	Duel.SkipPhase(tp,PHASE_DRAW,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_STANDBY,RESET_PHASE+PHASE_END,2)
	Duel.SkipPhase(tp,PHASE_MAIN1,RESET_PHASE+PHASE_END,2)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_EP)
	e4:SetTargetRange(1,0)
	e4:SetReset(RESET_PHASE+PHASE_MAIN1+RESET_SELF_TURN)
	Duel.RegisterEffect(e4,tp)
	end
end
function c511005078.atkcon(e)
	return e:GetHandler():GetFlagEffect(30606547)~=0
end
function c511005078.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c511005078.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(30606547)~=0 then return end
	e:GetHandler():RegisterFlagEffect(30606547,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_SELF_TURN,0,2)
	local sc=eg:GetFirst():GetFieldID()
	e:GetLabelObject():SetLabel(sc)
end
