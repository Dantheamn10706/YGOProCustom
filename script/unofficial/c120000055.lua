--機皇創世
function c120000055.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000055,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c120000055.condition)
	e1:SetCost(c120000055.cost)
	e1:SetTarget(c120000055.target)
	e1:SetOperation(c120000055.operation)
	c:RegisterEffect(e1)
end
function c120000055.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and c:IsCode(63468625)
end
function c120000055.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000055.filter,tp,0x13,0,1,nil,e,tp)
end
function c120000055.costfilter(c,code)
	return c:GetCode()==code and c:IsAbleToGraveAsCost()
end
function c120000055.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000055.costfilter,tp,LOCATION_HAND,0,1,nil,100000055)
	and Duel.IsExistingMatchingCard(c120000055.costfilter,tp,LOCATION_HAND,0,1,nil,100000066) 
	and Duel.IsExistingMatchingCard(c120000055.costfilter,tp,LOCATION_HAND,0,1,nil,100000067) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c120000055.costfilter,tp,LOCATION_HAND,0,1,1,nil,100000055)	
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,c120000055.costfilter,tp,LOCATION_HAND,0,1,1,nil,100000066)
	g1:Merge(g2)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g3=Duel.SelectMatchingCard(tp,c120000055.costfilter,tp,LOCATION_HAND,0,1,1,nil,100000067)
	g1:Merge(g3)
	Duel.SendtoGrave(g1,REASON_COST)
end
function c120000055.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsHasType(EFFECT_TYPE_ACTIVATE) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c120000055.filter,tp,0x13,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x13)
end
function c120000055.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c120000055.filter,tp,0x13,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end