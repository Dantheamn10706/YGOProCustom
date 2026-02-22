--メタモル・クレイ・フォートレス
function c120000284.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000284.condition)
	e1:SetTarget(c120000284.target)
	e1:SetOperation(c120000284.activate)
	c:RegisterEffect(e1)
	--Position
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_DAMAGE_STEP_END)
	e2:SetCondition(c120000284.poscon)
	e2:SetOperation(c120000284.posop)
	c:RegisterEffect(e2)
end
function c120000284.condition(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:GetControler()~=tp
end
function c120000284.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() 
end
function c120000284.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,120000284,0,0x21,1000,1000,4,RACE_ROCK,ATTRIBUTE_EARTH)	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000284.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,120000284,0,0x21,1000,1000,4,RACE_ROCK,ATTRIBUTE_EARTH) then return end
		c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
		Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
		c:AddMonsterAttributeComplete()
		if Duel.SpecialSummonComplete() and Duel.SelectEffectYesNo(tp,c,96) then 
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local tg=Duel.SelectMatchingCard(tp,c120000284.filter,tp,LOCATION_ONFIELD,0,1,1,c)
			if tg:GetCount()>0 then
				Duel.BreakEffect()
				local tc=tg:GetFirst()
				while tc do
					Duel.Equip(tp,tc,c,false,true)
					tc:RegisterFlagEffect(120000284,RESET_EVENT+0x1fe0000,0,0)
					local e1=Effect.CreateEffect(c)
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_EQUIP_LIMIT)
					e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
					e1:SetValue(c120000284.eqlimit)
					e1:SetReset(RESET_EVENT+0x1fe0000)
					tc:RegisterEffect(e1,true)
					tc=tg:GetNext()
				end
					Duel.EquipComplete()
		end	
			--atk
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
			e2:SetRange(LOCATION_MZONE)
			e2:SetValue(c120000284.atkval)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e2,true)
			local e3=e2:Clone()
			e3:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(e3,true)
	end
end
function c120000284.eqlimit(e,c)
	return e:GetOwner()==c
end
function c120000284.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(120000284)~=0 and tc:GetAttack()>=0 then
			atk=atk+tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end
function c120000284.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler()==Duel.GetAttacker() and e:GetHandler():IsRelateToBattle()
end
function c120000284.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsAttackPos() then
		Duel.ChangePosition(c,POS_FACEUP_DEFENSE)
	end
end
