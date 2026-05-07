--管魔人メロメロメロディ
function c120000096.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--chain attack
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000096,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetProperty(EFFECT_FLAG2_XMDETACH)
	e1:SetCondition(c120000096.atcon)
	e1:SetCost(c120000096.atcost)
	e1:SetOperation(c120000096.atop)
	c:RegisterEffect(e1)
end
function c120000096.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c120000096.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetAttacker()==c and c:IsChainAttackable(0,true) and Duel.IsExistingMatchingCard(c120000096.cfilter,tp,0,LOCATION_ONFIELD,1,nil)
end
function c120000096.atcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c120000096.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToBattle() then return end
	Duel.ChainAttack()
end