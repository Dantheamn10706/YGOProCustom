--ドラゴンを呼ぶ笛
function c120000131.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000131.condition)
	e1:SetOperation(c120000131.activate)
	c:RegisterEffect(e1)
end
function c120000131.cfilter(c)
	return c:IsFaceup() and c:IsCode(17985575)
end
function c120000131.dfilter(c)
	return c:IsRace(RACE_DRAGON)
end
function c120000131.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c120000131.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
		and Duel.IsExistingMatchingCard(c120000131.dfilter,tp,LOCATION_HAND,0,1,nil)
end
function c120000131.activate(e,tp,eg,ep,ev,re,r,rp)
	--special summon 1
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(120000131,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000131.spcon)
	e1:SetTarget(c120000131.sptg)
	e1:SetOperation(c120000131.spop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	--special summon 2
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetDescription(aux.Stringid(120000131,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_ADJUST)
	e2:SetCountLimit(1)
	e2:SetCondition(c120000131.spcon)
	e2:SetTarget(c120000131.sptg)
	e2:SetOperation(c120000131.spop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,1-tp)
end
function c120000131.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(c120000131.dfilter,tp,LOCATION_HAND,0,1,nil)
end
function c120000131.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c120000131.spfilter(c,e,tp)
	return c:IsRace(RACE_DRAGON) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000131.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if ft>2 then ft=2 end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c120000131.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp)
		and Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.SelectYesNo(tp,aux.Stringid(120000131,1)) then ft=1 end 
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(tp,c120000131.spfilter,tp,LOCATION_HAND,0,1,ft,nil,e,tp)
		if g1:GetCount()>0 then
		Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP)
	end
end