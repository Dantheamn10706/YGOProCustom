--幻奏の音女ソナタ
function c120000422.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000422.spcon)
	c:RegisterEffect(e1)
end
function c120000422.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x9b)
end
function c120000422.spcon(e,c)
	if c==nil then return true end
	return Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c120000422.filter,c:GetControler(),LOCATION_ONFIELD,0,1,nil)
end