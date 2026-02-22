--幻蝶の刺客オオルリ
function c120000164.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000164,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c120000164.spcon)
	e1:SetTarget(c120000164.sptg)
	e1:SetOperation(c120000164.spop)
	c:RegisterEffect(e1)
end
function c120000164.cfilter(c,tp)
	return c:IsFaceup() and c:IsAttackPos() and c:IsControler(tp)
end
function c120000164.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000164.cfilter,1,nil,tp)
end
function c120000164.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000164.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)~=0 then
		c:CompleteProcedure()
	elseif Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
