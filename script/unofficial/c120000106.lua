--ＤＴ デス・サブマリン
function c120000106.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000106,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,100000141+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(c120000106.spcon)
	e1:SetTarget(c120000106.sptg)
	e1:SetOperation(c120000106.spop)
	c:RegisterEffect(e1)
end
function c120000106.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000106.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c120000106.cfilter,tp,LOCATION_ONFIELD,0,nil)==0 
end
function c120000106.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c120000106.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end
