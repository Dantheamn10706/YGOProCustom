--階級制度
function c511001893.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511001893.condition)
	e1:SetTarget(c511001893.target)
	e1:SetOperation(c511001893.activate)
	c:RegisterEffect(e1)
end
function c511001893.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if ep==tp or not re:IsActiveType(TYPE_MONSTER) or not Duel.IsChainDisablable(ev) then return false end
	return a and a:IsRelateToBattle() and d and d:IsRelateToBattle() and a:IsControler(1-tp) and re:GetHandler()==a and d:IsControler(tp) and a:GetLevel()<=d:GetLevel()
end
function c511001893.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	end
end
function c511001893.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if Duel.NegateAttack(a) and re:GetHandler():IsRelateToEffect(re) and Duel.NegateEffect(ev) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_CHAIN_NEGATED)
		e1:SetReset(RESET_PHASE+PHASE_END)
		e1:SetOperation(c511001893.disop)
		Duel.RegisterEffect(e1,tp)
	end
end
function c511001893.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	e:Reset()
end