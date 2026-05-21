--ドドドボット
function c120000413.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e1:SetCondition(c120000413.sumcon)
	c:RegisterEffect(e1)
	--summon faceup def
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000413,0))
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_HAND)
	e2:SetCountLimit(1,120000413)
	e2:SetCondition(c120000413.nscon)
	e2:SetOperation(c120000413.nsop)
	e2:SetValue(SUMMON_TYPE_NORMAL)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetOperation(c120000413.atkop)
	c:RegisterEffect(e3)
end
function c120000413.sumcon(e,c,minc)
	if not c then return true end
	return false
end
function c120000413.nscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerAffectedByEffect(tp,EFFECT_DEVINE_LIGHT) and Duel.IsPlayerCanSummon(tp) and Duel.GetActivityCount(tp,ACTIVITY_NORMALSUMMON)==0 
	and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_MZONE)>0 
end
function c120000413.nsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
		Duel.MoveToField(c,tp,tp,LOCATION_MZONE,POS_FACEUP_DEFENSE,true)
		c:SetStatus(STATUS_SUMMON_TURN,true)
		Duel.RaiseSingleEvent(c,EVENT_SUMMON_SUCCESS,e,REASON_RULE,c:GetControler(),c:GetControler(),0)
		Duel.RaiseEvent(c,EVENT_SUMMON_SUCCESS,e,REASON_RULE,c:GetControler(),c:GetControler(),0)
end
function c120000413.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetValue(c120000413.efilter)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	c:RegisterEffect(e1)
end
function c120000413.efilter(e,te)
	return te:GetOwner()~=e:GetOwner() and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
