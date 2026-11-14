--RR－ネスト
function c120000320.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c120000320.condition)
	e2:SetTarget(c120000320.target)
	e2:SetOperation(c120000320.operation)
	c:RegisterEffect(e2)
end
function c120000320.cfilter(c,tp)
	return  c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xba) and Duel.IsExistingMatchingCard(c120000320.cfilter2,tp,LOCATION_ONFIELD,0,1,c,c:GetCode())
		and c:IsAbleToHand()
end
function c120000320.cfilter2(c,code)
	return  c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0xba) and c:IsCode(code)
end
function c120000320.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000320.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp)
end
function c120000320.filter(c,tp)
	return  c:IsType(TYPE_MONSTER) and c:IsSetCard(0xba) and c:IsAbleToHand() 
		and Duel.IsExistingMatchingCard(c120000320.cfilter2,tp,LOCATION_ONFIELD,0,1,c,c:GetCode())
end
function c120000320.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000320.filter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
end
function c120000320.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c120000320.filter),tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleDeck(tp)
	end
end