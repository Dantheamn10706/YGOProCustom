--ディフェンス・メイデン
function c120000074.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	c:RegisterEffect(e1)
	--Attack target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetCondition(c120000074.atcon)
	e2:SetValue(c120000074.atlimit)
	c:RegisterEffect(e2)
end
function c120000074.cfilter(c)
	return c:IsFaceup() and c:IsCode(100000139)
end
function c120000074.atcon(e)
	return Duel.IsExistingMatchingCard(c120000074.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c120000074.atlimit(e,c)
	return c:GetCode()~=100000139
end