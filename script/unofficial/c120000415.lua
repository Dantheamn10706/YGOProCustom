--ゴゴゴギガース
function c120000415.initial_effect(c)
	--cannot attack
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_OATH)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	c:RegisterEffect(e1)
end
