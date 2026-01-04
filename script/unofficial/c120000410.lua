--紋章の記録
function c120000410.initial_effect(c)
	Duel.EnableGlobalFlag(GLOBALFLAG_DETACH_EVENT)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c120000410.condition)
	e1:SetTarget(c120000410.target)
	e1:SetOperation(c120000410.activate)
	c:RegisterEffect(e1)
	if not c120000410.global_check then
		c120000410.global_check=true
		c120000410[0]=nil
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DETACH_MATERIAL)
		ge1:SetOperation(c120000410.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c120000410.checkop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetCurrentChain()
	if cid>0 then
		c120000410[0]=Duel.GetChainInfo(cid,CHAININFO_CHAIN_ID)
	end
end
function c120000410.condition(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp and Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)==c120000410[0] and re:IsActiveType(TYPE_XYZ) and Duel.IsChainNegatable(ev)
end
function c120000410.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c120000410.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
