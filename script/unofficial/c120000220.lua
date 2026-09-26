--トリック・ボックス
function c120000220.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000220,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetCondition(c120000220.condition)
	e1:SetTarget(c120000220.target)
	e1:SetOperation(c120000220.operation1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c120000220.condition2)
	e2:SetTarget(c120000220.target2)
	e2:SetOperation(c120000220.operation2)
	c:RegisterEffect(e2)
end
function c120000220.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	local bc=tc:GetBattleTarget()
	if tc:IsControler(1-tp) then
		tc,bc=bc,tc
	end
	if not tc or not bc or tc:IsControler(1-tp) or not tc:IsType(TYPE_MONSTER) or not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
		local tcind={tc:GetCardEffect(EFFECT_INDESTRUCTABLE_BATTLE)}
		for i=1,tcind do
			local te=tcind[i]
			local f=te:GetValue()
			if type(f)=='function' then
				if f(te,bc) then return false end
			else return false end
		end
	end
	e:SetLabelObject(tc)
	if bc==Duel.GetAttackTarget() and bc:IsDefensePos() then return false end
	if bc:IsPosition(POS_FACEUP_DEFENSE) and bc==Duel.GetAttacker() then
		if not bc:IsHasEffect(EFFECT_DEFENSE_ATTACK) then return false end
		if bc:IsHasEffect(75372290) then
			if tc:IsAttackPos() then
				return bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack()
			else
				return bc:GetAttack()>tc:GetDefense()
			end
		else
			if tc:IsAttackPos() then
				return bc:GetDefense()>0 and bc:GetDefense()>=tc:GetAttack()
			else
				return bc:GetDefense()>tc:GetDefense()
			end
		end
	else
		if tc:IsAttackPos() then
			return bc:GetAttack()>0 and bc:GetAttack()>=tc:GetAttack()
		else
			return bc:GetAttack()>tc:GetDefense()
		end
	end
end
function c120000220.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=e:GetLabelObject()
	if chk==0 then return g end
	Duel.SetTargetCard(g)
end
function c120000220.operation1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	if tc1 and tc1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.HintSelection(g)
		local tc2=g:GetFirst()
		if not Duel.SwapControl(tc1,tc2,0,0) then return end 
			local fid=c:GetFieldID()
			tc1:RegisterFlagEffect(120000220,RESET_EVENT+0x17a0000,0,0,fid)
			tc2:RegisterFlagEffect(120000220,RESET_EVENT+0x17a0000,0,0,fid)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(120000220,1))
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e4:SetCode(EVENT_LEAVE_FIELD)
			e4:SetCountLimit(1)
			e4:SetLabelObject(tc1)
			e4:SetLabel(fid)
			e4:SetCondition(c120000220.spbcon)
			e4:SetOperation(c120000220.spbop)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			Duel.RegisterEffect(e4,tp)
			local e5=e4:Clone()
			e5:SetLabelObject(tc2)
			Duel.RegisterEffect(e5,tp)
	end	
end
function c120000220.spfilter(c,fid)
	return c:GetFlagEffectLabel(120000220)==fid
end
function c120000220.spbcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ow=tc:GetOwner()
	return Duel.GetLocationCount(ow,LOCATION_MZONE)>0 and eg:IsExists(c120000220.spfilter,1,nil,e:GetLabel()) and tc and eg:IsContains(tc) 
	and tc:IsReason(REASON_DESTROY)
end
function c120000220.spbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SpecialSummon(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)
end
function c120000220.cfilter(c,e,tp)
	return c:IsOnField() and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and (not e or c:IsRelateToEffect(e))
end
function c120000220.condition2(e,tp,eg,ep,ev,re,r,rp)
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	if tg==nil or not (Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE) then return false end
	return ex and tg~=nil and tc+tg:FilterCount(c120000220.cfilter,nil,nil,tp)-tg:GetCount()>0
end
function c120000220.tgfilter(c,tp)
	return c:IsControler(tp) and c:IsType(TYPE_MONSTER)
end
function c120000220.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
	local cg=tg:Filter(c120000220.tgfilter,e:GetHandler(),tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local cd=cg:Select(tp,1,1,nil)
		Duel.SetTargetCard(cd)
end
function c120000220.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc1=Duel.GetFirstTarget()
	if tc1 and tc1:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e1:SetValue(1)
		e1:SetReset(RESET_CHAIN)
		tc1:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		tc1:RegisterEffect(e3)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
		local tg=Duel.SelectMatchingCard(tp,Card.IsAbleToChangeControler,tp,0,LOCATION_MZONE,1,1,nil)
		local tc2=tg:GetFirst()
		if Duel.SwapControl(tc1,tc2,0,0) then
			local fid=c:GetFieldID()
			tc1:RegisterFlagEffect(120000220,RESET_EVENT+0x17a0000,0,0,fid)
			tc2:RegisterFlagEffect(120000220,RESET_EVENT+0x17a0000,0,0,fid)
			local e4=Effect.CreateEffect(c)
			e4:SetDescription(aux.Stringid(120000220,1))
			e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
			e4:SetCode(EVENT_LEAVE_FIELD)
			e4:SetCountLimit(1)
			e4:SetLabelObject(tc1)
			e4:SetLabel(fid)
			e4:SetCondition(c120000220.specon)
			e4:SetOperation(c120000220.speop)
			e4:SetReset(RESET_EVENT+0x1fe0000)
			Duel.RegisterEffect(e4,tp)
			local e5=e4:Clone()
			e5:SetLabelObject(tc2)
			Duel.RegisterEffect(e5,tp)
		end	
	end
end
function c120000220.specon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local ow=tc:GetOwner()
	return Duel.GetLocationCount(ow,LOCATION_MZONE)>0 and eg:IsExists(c120000220.spfilter,1,nil,e:GetLabel()) and tc and eg:IsContains(tc) 
	and tc:IsReason(REASON_DESTROY)
end
function c120000220.speop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SpecialSummon(tc,0,tp,tc:GetOwner(),false,false,POS_FACEUP)
end
