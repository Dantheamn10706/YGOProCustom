--異次元の精霊
function c120000319.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000319.spcon)
	e1:SetOperation(c120000319.spop)
	c:RegisterEffect(e1)
end
function c120000319.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() 
end
function c120000319.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0 and Duel.IsExistingMatchingCard(c120000319.spfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000319.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c120000319.spfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
