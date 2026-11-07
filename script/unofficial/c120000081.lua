--エクシーズ・ダブル・バック
function c120000081.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000081,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROY)
	e1:SetCondition(c120000081.condition)
	e1:SetTarget(c120000081.target)
	e1:SetOperation(c120000081.activate)
	c:RegisterEffect(e1)
end
function c120000081.cfilter(c,tp)
	return c:IsType(TYPE_XYZ) and c:IsReason(REASON_BATTLE+REASON_EFFECT) and c:GetPreviousControler()==tp 
end
function c120000081.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000081.cfilter,1,nil,tp)
end
function c120000081.filter0(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000081.filter1(c,e,tp,turn)
	return c:IsType(TYPE_XYZ) and c:IsReason(REASON_DESTROY) and c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_MZONE)
		and c:IsPreviousPosition(POS_FACEUP) and c:GetTurnID()==turn and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.IsExistingTarget(c120000081.filter2,tp,LOCATION_GRAVE,0,1,c,e,tp,c:GetAttack())
end
function c120000081.filter2(c,e,tp,atk)
	return c:IsAttackBelow(atk) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000081.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>1 and Duel.GetMatchingGroupCount(c120000081.filter0,tp,LOCATION_ONFIELD,0,nil)==0
		and Duel.IsExistingTarget(c120000081.filter1,tp,LOCATION_GRAVE,0,1,nil,e,tp,Duel.GetTurnCount()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g1=Duel.SelectTarget(tp,c120000081.filter1,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,Duel.GetTurnCount())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g2=Duel.SelectTarget(tp,c120000081.filter2,tp,LOCATION_GRAVE,0,1,1,g1:GetFirst(),e,tp,g1:GetFirst():GetAttack())
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g1,2,0,0)
end
function c120000081.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()~=2 or Duel.GetLocationCount(tp,LOCATION_MZONE)<2 then return end
	local tc=g:GetFirst()
	while tc do
		if Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
			tc:RegisterFlagEffect(120000081,RESET_EVENT+0x1fe0000,0,1,Duel.GetTurnCount())
		end
		tc=g:GetNext()
	end
	Duel.SpecialSummonComplete()
	g:KeepAlive()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetLabel(Duel.GetTurnCount())
	e1:SetCondition(c120000081.descon)
	e1:SetOperation(c120000081.desop)
	e1:SetLabelObject(g)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
	Duel.RegisterEffect(e1,tp)
end
function c120000081.descon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() and Duel.GetTurnPlayer()==tp 
end
function c120000081.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,120000081)
	Duel.Destroy(tc,REASON_EFFECT)
end
