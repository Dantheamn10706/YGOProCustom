--フレイム・ウォール
function c120000119.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--avoid effect damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetValue(c120000119.damval)
	c:RegisterEffect(e2)
end
function c120000119.damval(e,re,val,r,rp,rc)
	if rp~=e:GetHandlerPlayer() and bit.band(r,REASON_EFFECT)~=0 then return 0
	else return val end
end