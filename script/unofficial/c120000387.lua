--ヒロイック・ギフト
function c120000387.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,120000387+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c120000387.condition)
	e1:SetTarget(c120000387.target)
	e1:SetOperation(c120000387.activate)
	c:RegisterEffect(e1)
end
function c120000387.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(1-tp)<=2000
end
function c120000387.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c120000387.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLP(1-tp)==4000 then return end
	Duel.SetLP(1-tp,4000) 
	Duel.Draw(tp,2,REASON_EFFECT)	
end
