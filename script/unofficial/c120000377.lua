--ヴォルカニック・バレット
function c120000377.initial_effect(c)
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000377,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1)
	e1:SetCost(c120000377.cost)
	e1:SetTarget(c120000377.tg)
	e1:SetOperation(c120000377.op)
	c:RegisterEffect(e1)
end
function c120000377.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
	Duel.RegisterFlagEffect(tp,120000377,RESET_PHASE+PHASE_END+RESET_EVENT+0x1fe0000,0,1)
end
function c120000377.filter(c)
	return c:IsCode(33365932) and c:IsAbleToHand()
end
function c120000377.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000377.filter,tp,LOCATION_DECK,0,1,nil) and Duel.GetFlagEffect(tp,120000377)==0 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c120000377.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsLocation(LOCATION_GRAVE) then return end
	local tc=Duel.GetFirstMatchingCard(c120000377.filter,tp,LOCATION_DECK,0,nil)
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end