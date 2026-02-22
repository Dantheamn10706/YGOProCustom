--拡散する波動
function c120000039.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000039.condition)
	e1:SetCost(c120000039.cost)
	e1:SetTarget(c120000039.target)
	e1:SetOperation(c120000039.activate)
	c:RegisterEffect(e1)
end
function c120000039.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP()
end
function c120000039.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c120000039.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(7) and c:IsAttackable() and c:GetAttackAnnouncedCount()==0
end
function c120000039.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000039.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000039.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000039.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c120000039.atkfilter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsAttackPos() and c:GetAttack()<atk and not c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) 
end
function c120000039.deffilter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsDefensePos() and c:GetDefense()<atk and not c:IsHasEffect(EFFECT_CANNOT_BE_BATTLE_TARGET) 
end
function c120000039.impfilter(c)
	return not c:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) and not c:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)
end
function c120000039.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local atk=tc:GetAttack()
	if tc:IsFaceup() and tc:IsControler(tp) and tc:IsRelateToEffect(e) then
	local ct1=Duel.GetMatchingGroupCount(c120000039.atkfilter,tp,0,LOCATION_MZONE,nil,atk)
	local ct2=Duel.GetMatchingGroupCount(c120000039.deffilter,tp,0,LOCATION_MZONE,nil,atk)
	local g1=Duel.GetMatchingGroup(c120000039.atkfilter,tp,0,LOCATION_MZONE,nil,atk)
	local g2=Duel.GetMatchingGroup(c120000039.deffilter,tp,0,LOCATION_MZONE,nil,atk)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BATTLED)
		e1:SetOperation(c120000039.disop)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		tc:RegisterEffect(e1)
		gt1=g1:FilterSelect(tp,c120000039.impfilter,ct1,ct1,nil,tp)
		Duel.ChangePosition(gt1,POS_FACEUP_ATTACK)
		if Duel.SendtoGrave(gt1,REASON_DESTROY+REASON_BATTLE)>0 then
			local sum1=g1:GetSum(Card.GetAttack)
			local cta=atk*ct1  
			Duel.Damage(1-tp,cta-sum1,REASON_BATTLE)
			Duel.RaiseEvent(gt1,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)	end
		gt2=g2:FilterSelect(tp,c120000039.impfilter,ct2,ct2,nil,tp)
		Duel.ChangePosition(gt2,POS_FACEUP_DEFENSE)
		if Duel.SendtoGrave(gt2,REASON_DESTROY+REASON_BATTLE)>0 then 
			Duel.RaiseEvent(gt2,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0) 
			if gt2:IsPreviousPosition(POS_DEFENSE) and tc:IsHasEffect(EFFECT_PIERCE) then
				local sum2=g2:GetSum(Card.GetDefense)
				local ctd=atk*ct2
				Duel.Damage(1-tp,ctd-sum2,REASON_BATTLE)
				end
			end
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetCode(EFFECT_CANNOT_ATTACK)
		e3:SetTargetRange(LOCATION_MZONE,0)
		e3:SetTarget(c120000039.ftarget)
		e3:SetLabel(tc:GetFieldID())
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e3,tp)
	end
end
function c120000039.ftarget(e,c)
	return e:GetLabel()~=c:GetFieldID()
end
function c120000039.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc or not bc:IsStatus(STATUS_BATTLE_DESTROYED) then return end
	local e1=Effect.CreateEffect(e:GetOwner())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetReset(RESET_EVENT+0x17a0000)
	bc:RegisterEffect(e1)
end