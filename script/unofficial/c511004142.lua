--スリーカード・サモン
function c511004142.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511004142.spcon)
	e1:SetOperation(c511004142.spop)
	c:RegisterEffect(e1)
end
function c511004142.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c511004142.sprfilter1,tp,LOCATION_HAND,0,3,nil,tp)
end
function c511004142.sprfilter1(c,tp)
	local lv=c:GetLevel()
	return lv<5 and Duel.IsExistingMatchingCard(c511004142.sprfilter2,tp,LOCATION_HAND,0,3,nil,lv)
end
function c511004142.sprfilter2(c,lv)
	return c:GetLevel()==lv and c:IsType(TYPE_MONSTER) and not c:IsPublic()
end
function c511004142.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c511004142.sprfilter1,tp,LOCATION_HAND,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local g2=Duel.SelectMatchingCard(tp,c511004142.sprfilter2,tp,LOCATION_HAND,0,1,3,nil,g1:GetFirst():GetLevel())
	g1:Merge(g2)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
		local sg=g1:Select(tp,3,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end