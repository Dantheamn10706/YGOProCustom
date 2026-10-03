--カウンター・ゲート
function c120000287.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW+CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000287.condition)
	e1:SetTarget(c120000287.target)
	e1:SetOperation(c120000287.activate)
	c:RegisterEffect(e1)
end
function c120000287.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:IsControler(1-tp) and at:IsAttackAbove(1500) and Duel.GetAttackTarget()==nil
end
function c120000287.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c120000287.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateAttack() and Duel.Draw(tp,1,REASON_EFFECT)~=0 then
		local tc=Duel.GetOperatedGroup():GetFirst()
		if tc:IsType(TYPE_MONSTER) and tc:IsSummonable(true,nil)
			and Duel.SelectYesNo(tp,aux.Stringid(94561645,0)) then
			Duel.Summon(tp,tc,true,nil)
		end
	end
end
