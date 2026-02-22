--翼の恩返し
function c511000736.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000736.cost)
	e1:SetTarget(c511000736.target)
	e1:SetOperation(c511000736.activate)
	c:RegisterEffect(e1)
end
function c511000736.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,600) end
	Duel.PayLPCost(tp,600)
end
function c511000736.drfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsRace(RACE_WINDBEAST)
end
function c511000736.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.GetMatchingGroupCount(c511000736.drfilter,tp,LOCATION_ONFIELD,0,nil)>0 end
	local ct=Duel.GetMatchingGroupCount(c511000736.drfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,ct)
end
function c511000736.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local ct=Duel.GetMatchingGroupCount(c511000736.drfilter,tp,LOCATION_ONFIELD,0,nil)
	local g=Duel.GetDecktopGroup(p,ct)
	Duel.Draw(p,ct,REASON_EFFECT)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
		e1:SetCode(EFFECT_FORBIDDEN)
		e1:SetTarget(c511000736.bantg)
		e1:SetLabelObject(tc)
		e1:SetTargetRange(0x7f,0x7f)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		tc=g:GetNext()
	end
end
function c511000736.bantg(e,c)
	return e:GetLabelObject()==c
end
