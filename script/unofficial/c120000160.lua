--タタカワナイト
function c120000160.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000160,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_CHAIN_NEGATED)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000160.damcon)
	e1:SetCost(c120000160.damcost)
	e1:SetTarget(c120000160.damtg)
	e1:SetOperation(c120000160.damop)
	c:RegisterEffect(e1)
end
function c120000160.cfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c120000160.damcon(e,tp,eg,ep,ev,re,r,rp)
	local de,dp=Duel.GetChainInfo(ev,CHAININFO_DISABLE_REASON,CHAININFO_DISABLE_PLAYER)
	local ct1=Duel.GetMatchingGroupCount(c120000160.cfilter,tp,LOCATION_ONFIELD,0,nil)
	local ct2=Duel.GetMatchingGroupCount(c120000160.cfilter,tp,0,LOCATION_ONFIELD,nil)
	return de and dp~=tp and de:GetHandler():IsType(TYPE_MONSTER) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and rp==tp and ct1==0 and ct2>0
end
function c120000160.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsRelateToEffect(e)
		and e:GetHandler():IsAbleToGraveAsCost() end
	Duel.SendtoGrave(e:GetHandler(),REASON_COST)
end
function c120000160.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1500)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1500)
end
function c120000160.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
