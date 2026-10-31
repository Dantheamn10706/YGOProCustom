--ＢＦ－弔風のデス
function c120000199.initial_effect(c)
	--material effect
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BE_MATERIAL)
	e1:SetCondition(c120000199.matcon)
	e1:SetOperation(c120000199.matop)
	c:RegisterEffect(e1)
end

function c120000199.matcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c120000199.matop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000199,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetLabel(1-tp)
	e1:SetCondition(c120000199.losecon)
	e1:SetCondition(c120000199.loseop)
	e1:SetReset(RESET_EVENT+0xc020000)
	rc:RegisterEffect(e1,true)
end
function c120000199.losecon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function c120000199.loseop(e,tp,eg,ep,ev,re,r,rp)
	local WIN_REASON_BLACKWING_DECAY_THE_III_WIND=0x80
	Duel.Win(e:GetLabel(),WIN_REASON_BLACKWING_DECAY_THE_III_WIND)
end