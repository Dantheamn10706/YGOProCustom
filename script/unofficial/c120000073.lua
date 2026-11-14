--理想のために
function c120000073.initial_effect(c)
	--destroy replace
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_END)
	e1:SetCondition(c120000073.condition)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000073,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c120000073.desreptg)
	e2:SetValue(c120000073.repval)
	c:RegisterEffect(e2)
	--remain field
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e3)
end
function c120000073.relfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsControler(tp) 
end
function c120000073.condition(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsExistingMatchingCard(c120000073.relfilter,tp,LOCATION_ONFIELD,0,2,nil,tp) then return end
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not d then return false end
	if d:IsControler(1-tp) then a,d=d,a end
	if not d or d:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then return false end
	if a:IsPosition(POS_FACEUP_DEFENSE) then
		if not a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
			if a:GetEffectCount(EFFECT_DEFENSE_ATTACK)==1 then
				if d:IsAttackPos() then
					if a:GetDefense()==d:GetAttack() and not d:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
						return a:GetDefense()~=0 
					else
						return a:GetDefense()>=d:GetAttack() 
					end
				else
					return a:GetDefense()>d:GetDefense() 
				end
			elseif a:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if d:IsAttackPos() then
					if a:GetAttack()==d:GetAttack() and not a:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
						return a:GetAttack()~=0 
					else
						return a:GetAttack()>=d:GetAttack() 
					end
				else
					return a:GetAttack()>d:GetDefense() 
				end
			end
		end
	else
		if d:IsAttackPos() then
			if a:GetAttack()==d:GetAttack() and not a:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
				return a:GetAttack()~=0 
			else
				return a:GetAttack()>=d:GetAttack()
			end
		else
			return a:GetAttack()>d:GetDefense() 
		end
	end
end
function c120000073.repfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_ONFIELD) and c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE) 
end
function c120000073.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ec=Duel.GetAttackTarget()
	if chk==0 then return eg:IsExists(c120000073.repfilter,1,nil,tp) end
	if Duel.IsExistingMatchingCard(c120000073.relfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectReleaseGroup(tp,c120000073.relfilter,1,1,ec,tp)
		Duel.Release(g,REASON_EFFECT)
		Duel.SendtoGrave(c,REASON_RULE)
		return true
	else return false end
end
function c120000073.repval(e,c)
	return c120000073.repfilter(c,e:GetHandlerPlayer())
end