--パンサー・シャーク
function c120000342.initial_effect(c)
	--summon with no tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000342,0))
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(c120000342.ntcon)
	c:RegisterEffect(e1)
end
function c120000342.sfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000342.ntcon(e,c,minc)
	if c==nil then return true end
	local ct=Duel.GetMatchingGroupCount(c120000342.sfilter,c:GetControler(),0,LOCATION_ONFIELD,nil)
	return minc==0 and c:GetLevel()>4 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
		and ct>1
end
