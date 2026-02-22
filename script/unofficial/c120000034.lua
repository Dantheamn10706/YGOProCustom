--H・C ソード・シールド
function c120000034.initial_effect(c)
	--Change Battle Damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetDescription(aux.Stringid(120000034,0))
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000034.con)
	e1:SetOperation(c120000034.op)
	c:RegisterEffect(e1)
end
function c120000034.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetLP(tp)>100 and Duel.GetBattleDamage(tp)>=2000 
end
function c120000034.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local LP=Duel.GetLP(tp)
	if c:IsAbleToGraveAsCost() and Duel.SelectEffectYesNo(tp,c) 
		and Duel.SendtoGrave(c,REASON_COST+REASON_REPLACE)>0 then
		Duel.ChangeBattleDamage(tp,LP-100)
	end
end
