--ゴゴゴ護符
function c120000247.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c120000247.indcon)
	e2:SetValue(c120000247.indct)
	c:RegisterEffect(e2)
	--reduce
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CHANGE_DAMAGE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(1,0)
	e3:SetCondition(c120000247.damcon)
	e3:SetValue(c120000247.damval)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetCode(EFFECT_SELF_DESTROY)
	e5:SetCondition(c120000247.descon)
	c:RegisterEffect(e5)
end
function c120000247.cfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x59)
end
function c120000247.indcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c120000247.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000247.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end
function c120000247.gfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x59)
end
function c120000247.damcon(e)
	return Duel.IsExistingMatchingCard(c120000247.gfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,2,nil)
end
function c120000247.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then return 0 end
	return val
end
function c120000247.descon(e)
	return not Duel.IsExistingMatchingCard(c120000247.gfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,1,nil)
end
