--DDDの人事権
function c120000366.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000366.target)
	e1:SetOperation(c120000366.operation)
	c:RegisterEffect(e1)
end
function c120000366.hfilter(c)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeck()
end
function c120000366.thfilter(c)
	return c:IsSetCard(0xaf) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c120000366.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000366.hfilter,tp,LOCATION_ONFIELD,0,3,e:GetHandler()) 
		and Duel.IsExistingMatchingCard(c120000366.thfilter,tp,LOCATION_DECK,0,2,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,3,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,0,tp,2)
end
function c120000366.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000366.hfilter,tp,LOCATION_ONFIELD,0,nil)
	if g:GetCount()>=2 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=g:Select(tp,3,3,nil)
		Duel.ConfirmCards(1-tp,sg)
		Duel.SendtoDeck(sg,nil,3,REASON_EFFECT)
		Duel.ShuffleDeck(tp)
		local dg=Duel.GetMatchingGroup(c120000366.thfilter,tp,LOCATION_DECK,0,nil)
		if dg:GetCount()==0 then return end
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local tg=dg:Select(tp,2,2,nil)
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
	end	
end
