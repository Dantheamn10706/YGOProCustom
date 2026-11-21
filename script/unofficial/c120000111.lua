--シンクロ・モンュメント
function c120000111.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--tuner summon success
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c120000111.tsumcon)
	e2:SetOperation(c120000111.sumsuc)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e4)
	--synchro summon success
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCondition(c120000111.ssumcon)
	e5:SetOperation(c120000111.sumsuc)
	c:RegisterEffect(e5)	
end
function c120000111.tsumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function c120000111.slimfilter(c)
	return c:GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c120000111.ssumcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000111.slimfilter,1,nil)
end
function c120000111.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTargetRange(1,1)
	e1:SetValue(c120000111.actlimit)
	e1:SetReset(RESET_EVENT+EVENT_ADJUST,2)
	c:RegisterEffect(e1)
end
function c120000111.actlimit(e,re,tp)
	return re:GetHandler():IsType(TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP) and re:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
