--グランエルＡ３
function c450000312.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c450000312.sdcon)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetValue(1)
	e2:SetCondition(c450000312.spcon)
	e2:SetOperation(c450000312.spop)
	c:RegisterEffect(e2)
	--equip
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_EQUIP)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCountLimit(1)
	e3:SetCondition(c450000312.eqcon)
	e3:SetOperation(c450000312.eqop)
	c:RegisterEffect(e3)
	--Attack Synchro
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(c450000312.atkcon)
	e4:SetTarget(c450000312.atktg)
	e4:SetOperation(c450000312.atkop)
	c:RegisterEffect(e4)
end
function c450000312.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsSetCard(0x3013)) 
end
function c450000312.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c450000312.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and not e:GetHandler():IsCode(63468625)
end
function c450000312.sdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c450000312.spfilter(c,code)
	return c:GetCode()==code
end
function c450000312.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c450000312.spfilter,1,nil,100000063)
end
function c450000312.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c450000312.spfilter,1,1,nil,100000063)
	Duel.Release(g1,REASON_COST)
end
function c450000312.eqcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local bc=tc:GetBattleTarget()
	return e:GetHandler():IsType(TYPE_MONSTER) and tc:IsRelateToBattle() and tc:IsStatus(STATUS_OPPO_BATTLE) and tc:IsControler(tp) and tc:IsSetCard(0x3013)
		and bc:IsType(TYPE_SYNCHRO) and bc:IsReason(REASON_BATTLE)
end
function c450000312.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local sg=Duel.SelectTarget(tp,c450000312.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	local eq=eg:GetFirst():GetBattleTarget()
	local tc=sg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if eq and eq:IsType(TYPE_SYNCHRO) and not eq:IsType(TYPE_EFFECT) then 
		local atk=eq:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,eq,tc,false) then return end
			--Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c450000312.eqlimit)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			eq:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetValue(TYPE_SYNCHRO+TYPE_MONSTER)
			e2:SetReset(RESET_EVENT+0x1fc0000)
			eq:RegisterEffect(e2)
			if atk>0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(atk)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				eq:RegisterEffect(e3)
			end	
			tc=sg:GetNext()
	elseif eq and eq:IsType(TYPE_SYNCHRO) and eq:IsType(TYPE_EFFECT) then 
		local atk=eq:GetTextAttack()
		if atk<0 then atk=0 end
		if not Duel.Equip(tp,eq,tc,false) then return end
			--Equip limit
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c450000312.eqlimit)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			eq:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetValue(TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
			e2:SetReset(RESET_EVENT+0x1fc0000)
			eq:RegisterEffect(e2)
			if atk>0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(atk)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				eq:RegisterEffect(e3)
			end	
			tc=sg:GetNext()	
		end
	else Duel.SendtoGrave(eq,REASON_EFFECT)
	end	
end
function c450000312.eqlimit(e,c)
	return not c:IsDisabled()
end
function c450000312.tgfilter(c)
	local ec=c:GetEquipTarget()
	return c:IsType(TYPE_SYNCHRO) and (ec:IsSetCard(0x3013) or ec:IsCode(63468625)) and c:GetFlagEffect(450000312)==0
end
function c450000312.atfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c450000312.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return e:GetHandler():IsType(TYPE_MONSTER) and Duel.GetTurnPlayer()==tp and ph>=0x08 and ph<=0x20 
	and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.IsExistingTarget(c450000307.tgfilter,tp,LOCATION_SZONE,0,1,nil,e,tp)
	and Duel.IsExistingTarget(c450000312.atfilter,tp,0,LOCATION_ONFIELD,1,nil,e,tp)
end
function c450000312.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_SZONE) end
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and Duel.IsExistingTarget(c450000312.tgfilter,tp,LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c450000312.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c450000312.atkop(e,tp,eg,ep,ev,re,r,rp)
	local ts=Duel.GetFirstTarget()
	local atks=ts:GetTextAttack()
	local sg=Duel.SelectTarget(tp,c450000312.atfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=sg:GetFirst()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackPos() and atks>tc:GetAttack() 
	and not (tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)) then
		local matk=tc:GetAttack()
		local difatk=atks-matk
		Duel.Damage(tc:GetControler(),difatk,REASON_BATTLE)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,tc:GetControler(),difatk)	
		Duel.SendtoGrave(tc,REASON_DESTROY+REASON_BATTLE)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		ts:RegisterFlagEffect(450000312,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	elseif tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackPos() and atks>tc:GetAttack() 
	and (tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)) then
		local matk=tc:GetAttack()
		local difatk=atks-matk
		Duel.Damage(tc:GetControler(),difatk,REASON_BATTLE)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,tc:GetControler(),difatk)
		ts:RegisterFlagEffect(450000312,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	elseif tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackPos() and atks==tc:GetAttack() 
	and not (tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)) then
		Duel.SendtoGrave(ts,REASON_DESTROY+REASON_BATTLE)
		Duel.SendtoGrave(tc,REASON_DESTROY+REASON_BATTLE)
		Duel.RaiseSingleEvent(ts,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseEvent(ts,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
	elseif tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackPos() and atks==tc:GetAttack() 
	and (tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)) then
		Duel.SendtoGrave(ts,REASON_DESTROY+REASON_BATTLE)
		Duel.RaiseSingleEvent(ts,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseSingleEvent(ts,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
	elseif tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsAttackPos() and atks<tc:GetAttack() then
		local matk=tc:GetAttack()
		local difatk=matk-atks
		Duel.Damage(ts:GetControler(),difatk,REASON_BATTLE)
		Duel.RaiseSingleEvent(ts,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,ts:GetControler(),difatk)	
		Duel.SendtoGrave(ts,REASON_DESTROY+REASON_BATTLE)
		Duel.RaiseSingleEvent(ts,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseEvent(ts,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		ts:RegisterFlagEffect(450000312,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)	
	elseif tc and tc:IsRelateToEffect(e) and tc:IsDefensePos() and atks>tc:GetDefense() 
	and not (tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) or tc:IsHasEffect(EFFECT_INDESTRUCTABLE_COUNT)) then
		local mdef=tc:GetDefense()
		local difdef=atks-mdef
		Duel.ChangePosition(tc,0,0,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
		Duel.Damage(tc:GetControler(),difdef,REASON_BATTLE)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,tc:GetControler(),difdef)	
		Duel.SendtoGrave(tc,REASON_DESTROY+REASON_BATTLE)
		Duel.RaiseSingleEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		Duel.RaiseEvent(tc,EVENT_BATTLE_DESTROYED,e,REASON_BATTLE,tp,tp,0)
		ts:RegisterFlagEffect(450000312,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	elseif tc and tc:IsRelateToEffect(e) and tc:IsDefensePos() and atks<tc:GetDefense() then
		local mdef=tc:GetAttack()
		local difdef=atks-mdef
		Duel.ChangePosition(tc,0,0,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
		Duel.Damage(ts:GetControler(),difdef,REASON_BATTLE)
		Duel.RaiseSingleEvent(ts,EVENT_BATTLE_DAMAGE,e,REASON_BATTLE,tp,ts:GetControler(),difdef)
		ts:RegisterFlagEffect(450000312,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end	
