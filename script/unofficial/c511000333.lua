--クイック・アタック
function c511000333.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511000333.condition)
	e1:SetTarget(c511000333.target)
	e1:SetOperation(c511000333.operation)
	c:RegisterEffect(e1)
end
function c511000333.filter(c)
	return c:GetAttackAnnouncedCount()==0 and c:IsFaceup() and c:IsLevelBelow(4)
end
function c511000333.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingTarget(c511000333.filter,tp,LOCATION_MZONE,0,1,nil)
end
function c511000333.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) or Duel.IsExistingTarget(c511000333.filter,tp,LOCATION_MZONE,0,1,nil) end
	local op=0
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(76922029,0))
	if Duel.GetTurnCount()==1 and Duel.IsPlayerCanDraw(tp,1) and (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_BATTLE) 
		and Duel.IsExistingTarget(c511000333.filter,tp,LOCATION_MZONE,0,1,nil) then
		op=Duel.SelectOption(tp,aux.Stringid(60694662,0),aux.Stringid(49121795,0))
	elseif Duel.GetTurnCount()==1 and Duel.IsExistingTarget(c511000333.filter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsPlayerCanDraw(tp,1) then
		Duel.SelectOption(tp,aux.Stringid(49121795,0))
		op=1 	
	else
		Duel.SelectOption(tp,aux.Stringid(60694662,0))
		op=0
	end
	e:SetLabel(op)
	if op==0 then
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
end
function c511000333.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	else
		--attack
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetCode(EFFECT_BP_FIRST_TURN)
		e1:SetTargetRange(LOCATION_MZONE,0)
		e1:SetTarget(c511000333.atktg1)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IGNORE_IMMUNE)
		e2:SetCode(EFFECT_CANNOT_ATTACK)
		e2:SetTargetRange(LOCATION_MZONE,0)
		e2:SetTarget(c511000333.atktg2)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
	end
end
function c511000333.atktg1(e,c)
	return c:IsLevelBelow(4)
end
function c511000333.atktg2(e,c)
	return c:IsLevelAbove(5)
end