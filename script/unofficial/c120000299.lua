--機甲忍者ブレード・ハート
function c120000299.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,4,2)
	c:EnableReviveLimit()
	--attack again
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000299,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG2_XMDETACH)
	e1:SetCode(EVENT_BATTLED)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c120000299.condition)
	e1:SetCost(c120000299.cost)
	e1:SetOperation(c120000299.operation)
	c:RegisterEffect(e1)
end
function c120000299.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return c==Duel.GetAttacker() and bc and bc:IsRelateToBattle() 
end
function c120000299.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c120000299.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
end
