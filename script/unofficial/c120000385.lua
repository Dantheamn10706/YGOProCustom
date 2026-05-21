--H・C アンブッシュ・ソルジャー
function c120000385.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000385,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c120000385.spcon)
	e1:SetCost(c120000385.spcost)
	e1:SetTarget(c120000385.sptg)
	e1:SetOperation(c120000385.spop)
	c:RegisterEffect(e1)
end
function c120000385.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:GetTurnID()~=Duel.GetTurnCount()
end	
function c120000385.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c120000385.filter(c,e,tp)
	return c:IsLevelBelow(4) and c:IsSetCard(0x106f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000385.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1
		and Duel.IsExistingMatchingCard(c120000385.filter,tp,LOCATION_HAND,0,2,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,2,tp,LOCATION_HAND)
end
function c120000385.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=1 then return end
	local g=Duel.GetMatchingGroup(c120000385.filter,tp,LOCATION_HAND,0,nil,e,tp)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,2,2,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		local tc=sg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_LEVEL)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		tc=sg:GetNext()
	end
end
