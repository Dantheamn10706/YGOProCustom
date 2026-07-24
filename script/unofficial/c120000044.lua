--デモンバルサム・シード
function c120000044.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000044,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c120000044.condition)
	e1:SetOperation(c120000044.operation)
	c:RegisterEffect(e1)
end
function c120000044.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if tc:IsControler(1-tp) then
		tc=Duel.GetAttackTarget()
		bc=Duel.GetAttacker()
	end
	if not tc or not bc or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) 
		or not tc:IsPosition(POS_FACEUP_ATTACK) then return false end
	if bc==Duel.GetAttackTarget() and bc:IsDefensePos() then return false end
	if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
		if not bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
			if bc:GetEffectCount(EFFECT_DEFENSE_ATTACK)==1 then
				if bc:GetDefense()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
					return bc:GetDefense()~=0
				else
					return bc:GetDefense()>=tc:GetAttack()
				end
			elseif bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then
				if bc:GetAttack()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
					return bc:GetAttack()~=0
				else
					return bc:GetAttack()>=tc:GetAttack()
				end
			end
		end
	else
		if bc:GetAttack()==tc:GetAttack() and not bc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
			return bc:GetAttack()~=0
		else
			return bc:GetAttack()>=tc:GetAttack()
		end
	end
end
function c120000044.operation(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e1:SetTarget(c120000044.damtg)
	e1:SetOperation(c120000044.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c120000044.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local red=math.floor(ev/1000)
	local red2=(red*1000)
	local dam=(ev-red2)
	if chk==0 then return red and red>0 and (red==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>=red
		and Duel.IsPlayerCanSpecialSummonMonster(tp,60406592,0,0x4011,100,100,1,RACE_PLANT,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,red,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,red,tp,0)
end
function c120000044.damop(e,tp,eg,ep,ev,re,r,rp)
	local red=math.floor(ev/1000)
	local red2=(red*1000)
	local dam=(ev-red2)
	if (Duel.IsPlayerAffectedByEffect(tp,59822133)) or red<0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<red
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,60406592,0,0x4011,100,100,1,RACE_PLANT,ATTRIBUTE_DARK) then red=0 end
		Duel.ChangeBattleDamage(tp,dam)
	for i=1,red do
		local token=Duel.CreateToken(tp,60406592)
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
	Duel.SpecialSummonComplete()
	Duel.SkipPhase(Duel.GetTurnPlayer(),PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
end
