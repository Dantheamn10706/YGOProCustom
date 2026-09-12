--ゴルゴニック・ガーゴイル
function c120000354.initial_effect(c)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000354,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000354.spcon)
	e1:SetTarget(c120000354.sptg)
	e1:SetOperation(c120000354.spop)
	c:RegisterEffect(e1)
end
c120000354.collection={
	[37168514]=true;[64379261]=true;[90764875]=true;[37984162]=true;[84401683]=true;
}
function c120000354.cfilter(c,tp)
	return c120000354.collection[c:GetCode()]
end
function c120000354.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000354.cfilter,1,nil,tp)
end
function c120000354.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000354.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
