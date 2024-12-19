--デルタ・クロウ－アンチ・リバース
function c120000204.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000204,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c120000204.condition)
	e1:SetTarget(c120000204.target)
	e1:SetOperation(c120000204.activate)
	c:RegisterEffect(e1)
	--act in hand
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e2:SetCondition(c120000204.handcon)
	c:RegisterEffect(e2)
end
function c120000204.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x33)
end
function c120000204.handcon(e)
	return Duel.GetMatchingGroupCount(c120000204.cfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)>=3
end
function c120000204.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000204.cfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c120000204.filter(c)
	return c:IsFacedown()
end
function c120000204.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000204.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(c120000204.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c120000204.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000204.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
