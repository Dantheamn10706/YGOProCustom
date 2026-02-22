--ディフェンダーズ・クロス
function c120000205.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000205.condition)
	e1:SetTarget(c120000205.target)
	e1:SetOperation(c120000205.operation)
	c:RegisterEffect(e1)
end
function c120000205.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c120000205.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,0,LOCATION_MZONE,1,nil) 
		and Duel.IsExistingMatchingCard(Card.IsDefensePos,tp,LOCATION_MZONE,0,1,nil) end
end
function c120000205.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectMatchingCard(tp,Card.IsDefensePos,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TARGET)
	local g2=Duel.SelectMatchingCard(1-tp,Card.IsDefensePos,1-tp,LOCATION_MZONE,0,1,1,nil,e,1-tp):GetFirst()
	local tc=Group.FromCards(g1,g2)
	if g1 and g2 then
		Duel.ChangePosition(tc,0,0,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		g1:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		g1:RegisterEffect(e2)
		local e3=e1:Clone()
		g2:RegisterEffect(e3)
		local e4=e2:Clone()
		g2:RegisterEffect(e4)
		Duel.CalculateDamage(g1,g2)
	end
end