--異次元トンネル－ミラーゲート－
function c511310017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)	
	e1:SetCondition(c511310017.condition)
	e1:SetTarget(c511310017.target)
	e1:SetOperation(c511310017.activate)
	c:RegisterEffect(e1)
end
function c511310017.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if not at then return false end
	if tc:IsControler(1-tp) then tc=at end
	return tc:IsControler(tp) and tc:IsLocation(LOCATION_MZONE)
end
function c511310017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if chk==0 then return a:IsOnField() and a:IsAbleToChangeControler()
		and at:IsOnField() and at:IsAbleToChangeControler() end
	local g=Group.FromCards(a,at)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,2,0,0)
end
function c511310017.activate(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local at=Duel.GetAttackTarget()
	if a:IsRelateToEffect(e) and a:IsAttackable() and at:IsRelateToEffect(e) then
		if Duel.SwapControl(a,at,RESET_PHASE+PHASE_END,1) then
			Duel.CalculateDamage(a,at)
		end
	end
end
