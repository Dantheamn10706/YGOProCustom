--ジャンク・コレクター
function c120000316.initial_effect(c)
	--copy trap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000316,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e1)
	e1:SetCost(c120000316.cost)
	e1:SetTarget(c120000316.target)
	e1:SetOperation(c120000316.operation)
	c:RegisterEffect(e1)
end
function c120000316.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToGraveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c120000316.filter(c)
	return (c:GetType()==TYPE_TRAP or c:GetType()==0x20004 or c:GetType()==0x100000) and c:IsAbleToGrave() and c:CheckActivateEffect(false,true,false)~=nil
end
function c120000316.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000316.filter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_GRAVE)
end
function c120000316.operation(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(58242947,1))
	local g=Duel.SelectMatchingCard(tp,c120000316.filter,tp,LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		local te,eg,ep,ev,re,r,rp=g:GetFirst():CheckActivateEffect(false,true,false)
		e:SetLabelObject(te)
		Duel.ClearTargetCard()
		local co=te:GetCost()
		local tg=te:GetTarget()
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end
	end
end