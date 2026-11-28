--地縛霊の誘い
function c120000066.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000066,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_BATTLE_START)
	e1:SetCondition(c120000066.condition)
	e1:SetTarget(c120000066.target)
	e1:SetOperation(c120000066.activate)
	c:RegisterEffect(e1)
end
function c120000066.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE)
end
function c120000066.filter(c)
	return c:IsPosition(POS_FACEUP_ATTACK) or c:IsHasEffect(EFFECT_DEFENSE_ATTACK) and c:GetAttackAnnouncedCount()<=0 and c:GetFlagEffect(120000066)==0 
		and c:IsAttackable()
end
function c120000066.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c120000066.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000066.filter,tp,0,LOCATION_MZONE,1,nil)
    and Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g1=Duel.SelectTarget(tp,c120000066.filter,tp,0,LOCATION_MZONE,1,1,nil)
	e:SetLabelObject(g1:GetFirst())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g2=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,g1:GetFirst())
end
function c120000066.activate(e,tp,eg,ep,ev,re,r,rp)
	local hc=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	local c1=tg:GetFirst()
	local c2=tg:GetNext()
	if tg:GetCount()==2 then
		if c1 and c1:IsPosition(POS_FACEUP_ATTACK) or c1:IsHasEffect(EFFECT_DEFENSE_ATTACK) and c1:IsRelateToEffect(e) and c1:IsAttackable()
			and not c1:IsImmuneToEffect(e) then
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			c1:RegisterEffect(e1)
			c1:RegisterFlagEffect(120000066,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
		Duel.CalculateDamage(c1,c2,true)
		end	
	end
end
