--魂の一撃
function c120000048.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(120000048,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000048.condition)
	e1:SetCost(c120000048.cost)
	e1:SetTarget(c120000048.target)
	e1:SetOperation(c120000048.activate)
	c:RegisterEffect(e1)
end
function c120000048.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)<=2000
end
function c120000048.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lp=math.floor(Duel.GetLP(tp)/2)
	Duel.PayLPCost(tp,lp)
	Duel.SetTargetParam(lp)
end
function c120000048.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c120000048.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000048.filter,tp,LOCATION_ONFIELD,0,1,nil) end
end
function c120000048.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c120000048.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM))
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
	end
end
