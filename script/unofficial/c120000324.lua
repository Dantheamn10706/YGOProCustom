--ダメージ・ダイエット
function c120000324.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c120000324.activate)
	c:RegisterEffect(e1)
end
function c120000324.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,95448692)~=0 then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetValue(c120000324.val)
	e1:SetReset(RESET_PHASE+PHASE_END,1)
	Duel.RegisterEffect(e1,tp)
end
function c120000324.val(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		return dam/2
	else return dam end
end
