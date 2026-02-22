--野生の咆哮
function c120000149.initial_effect(c)
	--damage
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000149,0))
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYING)
	e1:SetCondition(c120000149.condition)
	e1:SetTarget(c120000149.target)
	e1:SetOperation(c120000149.operation)
	c:RegisterEffect(e1)
end
function c120000149.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return tc:IsRelateToBattle() and tc:IsStatus(STATUS_OPPO_BATTLE) and tc:IsControler(tp) and tc:IsRace(RACE_BEAST) and bc:IsReason(REASON_BATTLE)
end
function c120000149.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_BEAST)
end
function c120000149.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	local dam=Duel.GetMatchingGroupCount(c120000149.filter,tp,LOCATION_ONFIELD,0,nil)*300
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function c120000149.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local dam=Duel.GetMatchingGroupCount(c120000149.filter,tp,LOCATION_ONFIELD,0,nil)*300
	Duel.Damage(p,dam,REASON_EFFECT)
end
