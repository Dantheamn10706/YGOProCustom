--フォトン・リード
function c120000253.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000253.target)
	e1:SetOperation(c120000253.activate)
	c:RegisterEffect(e1)
	if not c120000253.global_check then
		c120000253.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_HAND)
		ge1:SetOperation(c120000253.op)
		Duel.RegisterEffect(ge1,0)
	end
end
function c120000253.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_HAND) and bit.band(r,REASON_EFFECT)~=0 and tc:IsLevelBelow(4) and tc:IsAttribute(ATTRIBUTE_LIGHT) then
			tc:RegisterFlagEffect(120000253,RESET_PHASE+0x1fe0000+PHASE_END,0,1)
		end
		tc=eg:GetNext()
	end
end
function c120000253.filter(c)
	local tid=Duel.GetTurnCount()
	return c:IsLevelBelow(4) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsAbleToHand() and c:GetFlagEffect(120000253)>0 and c:GetTurnID()==tid 
end
function c120000253.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c120000253.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c120000253.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c120000253.filter,tp,LOCATION_HAND,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP_ATTACK)
	end
end
