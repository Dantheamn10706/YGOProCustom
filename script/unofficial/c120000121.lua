--インフィニティ・フォース
function c120000121.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000121,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c120000121.damcon)
	e1:SetOperation(c120000121.damop)
	c:RegisterEffect(e1)
end
function c120000121.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x3013)
end
function c120000121.damcon(e,tp,eg,ep,ev,re,r,rp)
	return aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and Duel.IsExistingMatchingCard(c120000121.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000121.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000121.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c120000121.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	if c:IsRelateToEffect(e) then
	local g=Duel.GetMatchingGroup(c120000121.filter,tp,0,LOCATION_ONFIELD,nil)
	if g:GetCount()<=0 then return end
		Duel.Destroy(g,REASON_EFFECT)
	end	
end
function c120000121.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0 end
	return val
end