--仲裁の代償
function c511002404.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511002404.condition)
	e1:SetTarget(c511002404.target)
	e1:SetOperation(c511002404.activate)
	c:RegisterEffect(e1)
end
function c511002404.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a and a:GetControler()==1-tp and (Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=3 or Duel.GetLocationCount(1-tp,LOCATION_MZONE)>=3)
end
function c511002404.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_GRAVE,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,nil,2,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c511002404.activate(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,0,LOCATION_GRAVE,nil)
	local g1=Duel.GetLocationCount(1-tp,LOCATION_SZONE)
	local g2=Duel.GetLocationCount(1-tp,LOCATION_MZONE)
	local opt=0
	if g1>=3 and g2>=3 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(5012,11),aux.Stringid(5012,12))
	elseif g1>=3 and g2<3 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(5012,11))
	elseif g2>0 and g1<3 then
		opt=Duel.SelectOption(1-tp,aux.Stringid(5012,12))+1
	else return end
	if opt==0 then
		local sg=g:Select(1-tp,2,2,nil)
		sg:AddCard(c)
		c:CancelToGrave()
		Duel.SendtoHand(sg,1-tp,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SSet(1-tp,sg)
		Duel.ShuffleSetCard(sg)
		local rsel=sg:RandomSelect(tp,1)
		Duel.ConfirmCards(1-tp,rsel)
		if rsel:IsContains(c) then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
			sg:RemoveCard(c)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.SendtoGrave(c,REASON_EFFECT)
		else
			Duel.SendtoGrave(sg,REASON_EFFECT) 
		end
	else
		local sg=g:Select(1-tp,2,2,nil)
		sg:AddCard(c)
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,1-tp,1-tp,LOCATION_MZONE,POS_FACEDOWN_ATTACK,true)
			tc=sg:GetNext()
		end
		Duel.ShuffleSetCard(sg)
		local rsel=sg:RandomSelect(tp,1)
		Duel.ConfirmCards(tp,rsel)
		Duel.ConfirmCards(1-tp,rsel)
		if rsel:IsContains(c) then
			Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
			sg:RemoveCard(c)
			Duel.SendtoDeck(sg,nil,0,REASON_EFFECT)
			Duel.SendtoGrave(c,REASON_EFFECT)
		else
			Duel.SendtoGrave(sg,REASON_EFFECT) 
		end
	end		
end