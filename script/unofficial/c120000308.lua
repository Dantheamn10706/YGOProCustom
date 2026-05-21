--ヒドゥン・ショット
function c120000308.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c120000308.cost)
	e1:SetTarget(c120000308.target)
	e1:SetOperation(c120000308.activate)
	c:RegisterEffect(e1)
end
function c120000308.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	return true
end
function c120000308.cfilter(c)
	return c:IsSetCard(0x2016) and c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost()
end
function c120000308.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000308.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() end
	if chk==0 then
		if e:GetLabel()==1 then
			e:SetLabel(0)
			return Duel.IsExistingMatchingCard(c120000308.cfilter,tp,LOCATION_GRAVE,0,1,nil)
				and Duel.IsExistingTarget(c120000308.filter,tp,0,LOCATION_ONFIELD,1,nil)
		else return false end
	end
	e:SetLabel(0)
	local cg=Duel.SelectMatchingCard(tp,c120000308.cfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(cg,POS_FACEUP,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c120000308.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c120000308.activate(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then 
		Duel.Destroy(tc,REASON_EFFECT)
	end
end