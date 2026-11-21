--グランドラン
function c120000414.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_SPSUM_PARAM)
	e1:SetRange(LOCATION_HAND)
	e1:SetTargetRange(POS_FACEUP_ATTACK,0)
	e1:SetCondition(c120000414.spcon)
	c:RegisterEffect(e1)
	--XYZ Material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e2:SetValue(c120000414.xyzlimit)
	c:RegisterEffect(e2)
end
function c120000414.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_XYZ)
end
function c120000414.spcon(e,c)
	if c==nil then return true end
	local ct=Duel.GetMatchingGroupCount(c120000414.filter,tp,0,LOCATION_ONFIELD,nil)
	return ct>0
end
function c120000414.xyzlimit(e,c)
	if not c then return false end
	return not c:IsAttribute(ATTRIBUTE_EARTH)
end