--ハイレート・ドロー
function c120000082.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000082.target)
	e1:SetOperation(c120000082.activate)
	c:RegisterEffect(e1)
end
function c120000082.dfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000082.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000082.dfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetTargetPlayer(tp)
end
function c120000082.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local sg=Duel.GetMatchingGroup(c120000082.dfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct=Duel.Destroy(sg,REASON_EFFECT)		
	if ct>0	then
		local dc=math.floor(ct/2)
		Duel.BreakEffect()
		Duel.Draw(p,dc,REASON_EFFECT)
	end
end