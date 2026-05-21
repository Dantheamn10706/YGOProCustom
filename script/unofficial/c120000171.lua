--スターゲート
function c120000171.initial_effect(c)
	c:EnableCounterPermit(0x1e)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Add counter
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000171,0))
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetOperation(c120000171.ctop)
	c:RegisterEffect(e2)
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000171,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c120000171.spcon)
	e3:SetCost(c120000171.spcost)
	e3:SetTarget(c120000171.sptg)
	e3:SetOperation(c120000171.spop)
	c:RegisterEffect(e3)
end
function c120000171.cfilter(c)
	return c:GetBattledGroupCount()~=0
end
function c120000171.ctop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(c120000171.cfilter,tp,0,LOCATION_MZONE,nil)
	e:GetHandler():AddCounter(0x1e,ct)
end
function c120000171.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
end
function c120000171.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	e:SetLabel(e:GetHandler():GetCounter(0x1e))
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c120000171.filter(c,e,tp,lv)
	return c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000171.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c120000171.filter,tp,LOCATION_HAND,0,1,nil,e,tp,e:GetHandler():GetCounter(0x1e)) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c120000171.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c120000171.filter,tp,LOCATION_HAND,0,1,1,nil,e,tp,e:GetLabel())
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
