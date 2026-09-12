--セルケトの紋章
function c511001306.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c511001306.actcon)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
	--sp summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(511001306,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c511001306.spcon)
	e3:SetTarget(c511001306.sptg)
	e3:SetOperation(c511001306.spop)
	c:RegisterEffect(e3)
end
function c511001306.scfilter(c,code)
	return c:IsFaceup() and c:IsCode(code) and c:GetFlagEffect(511001306)==0
end
function c511001306.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511001306.scfilter,tp,LOCATION_ONFIELD,0,1,nil,29762407)
end
function c511001306.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511001306.scfilter,tp,LOCATION_ONFIELD,0,1,nil,511001305)
		and Duel.IsExistingMatchingCard(c511001306.scfilter,tp,LOCATION_ONFIELD,0,1,nil,29762407)
		and e:GetHandler():GetFlagEffect(511001305)==0
end 
function c511001306.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and not e:GetHandler():IsStatus(STATUS_CHAINING) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,120000120,0,0x21,2500,2000,6,RACE_FAIRY,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c511001306.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511001306.scfilter,tp,LOCATION_ONFIELD,0,nil,511001305)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local dg=g:Select(tp,1,1,nil):GetFirst()
	dg:RegisterFlagEffect(511001306,RESET_EVENT+RESETS_STANDARD,0,1)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,120000120,0,0x21,2500,2000,6,RACE_FAIRY,ATTRIBUTE_EARTH) then return end
		local serket=Duel.CreateToken(tp,120000120)
		Duel.SpecialSummonStep(serket,0,tp,tp,false,false,POS_FACEUP)
		--atkup
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(120000120,0))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_BATTLE_DESTROYING)
		e1:SetCondition(c511001306.atkcon1)
		e1:SetOperation(c511001306.atkop)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		serket:RegisterEffect(e1,true)
		--double tribute
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DOUBLE_TRIBUTE)
		e2:SetValue(1)
		e2:SetCondition(c511001306.matcon1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		serket:RegisterEffect(e2,true)
		--triple tribute
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_TRIPLE_TRIBUTE)
		e3:SetValue(1)
		e3:SetCondition(c511001306.matcon2)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		serket:RegisterEffect(e3,true)
		--count
		c511001306[0]=0
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLE_DESTROYING)
		e4:SetCondition(c511001306.atkcon2)
		e4:SetOperation(c511001306.countop)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD)
		serket:RegisterEffect(e4,true)
		Duel.SpecialSummonComplete()	
	c:RegisterFlagEffect(511001305,RESET_EVENT+RESETS_STANDARD,0,1)	
end
function c511001306.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsType(TYPE_MONSTER) and c:IsRelateToBattle() 
end
function c511001306.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local atk=bc:GetAttack()
	if c:IsFacedown() or not c:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(atk)
	e1:SetReset(RESET_EVENT+0x1ff0000)
	c:RegisterEffect(e1)
	
end
function c511001306.atkcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc:IsType(TYPE_MONSTER) and c:IsRelateToBattle() and c:GetFlagEffect(511001305)==0
end
function c511001306.countop(e,tp,eg,ev,ep,re,r,rp)
	c511001306[ep]=c511001306[ep]+1
	e:GetHandler():RegisterFlagEffect(tp,511001306,RESET_EVENT+RESETS_STANDARD,0,1)
end
function c511001306.matcon1(e)
	return c511001306[0]==2
end
function c511001306.matcon2(e)
	return c511001306[0]>2
end