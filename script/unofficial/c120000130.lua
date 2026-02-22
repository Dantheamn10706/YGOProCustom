--無限牢
function c120000130.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000130,0))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c120000130.cost1)
	e1:SetTarget(c120000130.target1)
	e1:SetOperation(c120000130.activate1)
	c:RegisterEffect(e1)
	--instant
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000130,0))
	e2:SetCategory(CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c120000130.cost2)
	e2:SetTarget(c120000130.target2)
	e2:SetOperation(c120000130.activate2)
	c:RegisterEffect(e2)
	--to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000130,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCost(c120000130.cost3)
	e3:SetTarget(c120000130.target3)
	e3:SetOperation(c120000130.activate3)
	c:RegisterEffect(e3)
end
function c120000130.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(0)
	if Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.SelectYesNo(tp,aux.Stringid(120000130,0)) then
		e:GetHandler():RegisterFlagEffect(120000130,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
		e:SetLabel(1)
		Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	 else e:SetProperty(0)
	 end
end
function c120000130.filter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000130.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c120000130.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c120000130.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c120000130.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c120000130.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if e:GetLabel()~=1 then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_SPELL)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	tc:RegisterEffect(e1)
	Duel.RaiseEvent(tc,500313101,e,0,tp,0,0)
	local sg=e:GetLabelObject()
	tc:RegisterFlagEffect(500313101,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c120000130.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,e:GetHandler()) and e:GetHandler():GetFlagEffect(500313101)==0 end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	e:GetHandler():RegisterFlagEffect(500313101,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function c120000130.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and c120000130.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c120000130.filter,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.SelectTarget(tp,c120000130.filter,tp,LOCATION_GRAVE,0,1,1,nil)
end
function c120000130.activate2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetValue(TYPE_SPELL)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	tc:RegisterEffect(e1)
	Duel.RaiseEvent(tc,500313101,e,0,tp,0,0)
	local sg=e:GetLabelObject()
	tc:RegisterFlagEffect(500313101,RESET_EVENT+0x1fe0000,0,1)
	end
end
function c120000130.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c120000130.filter2(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand() and c:GetFlagEffect(500313101)~=0
end
function c120000130.target3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(c120000130.filter2,tp,LOCATION_SZONE,0,1,c) end
	local sg=Duel.GetMatchingGroup(c120000130.filter2,tp,LOCATION_SZONE,0,c)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,sg,sg:GetCount(),0,0)
end
function c120000130.activate3(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(c120000130.filter2,tp,LOCATION_SZONE,0,e:GetHandler())
	Duel.SendtoHand(sg,nil,REASON_EFFECT)
end