--魔法効果の矢
function c511002052.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511002052,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c511002052.condition)
	e1:SetTarget(c511002052.target)
	e1:SetOperation(c511002052.activate)
	c:RegisterEffect(e1)
	--Reflect spell
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(511002052,1))
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(c511002052.chcon)
	e2:SetOperation(c511002052.chop)
	c:RegisterEffect(e2)
	--Change the effect target of an Spell Card
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetDescription(aux.Stringid(511002052,2))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCondition(c511002052.efcon)
	e3:SetTarget(c511002052.eftg)
	e3:SetOperation(c511002052.efop)
	c:RegisterEffect(e3)
	--Reflect Summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(511002052,3))
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCondition(c511002052.sumcon)
	e4:SetOperation(c511002052.sumop)
	c:RegisterEffect(e4)
	--Copy Spell
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(511002052,4))
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCondition(c511002052.egcon)
	e5:SetTarget(c511002052.target2)
	e5:SetOperation(c511002052.operation2)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(511001408)
	c:RegisterEffect(e6)
	aux.GlobalCheck(c511002052,function()
		--register
		local ac=Effect.CreateEffect(c)
		ac:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ac:SetCode(EVENT_CHAINING)
		ac:SetCondition(c511002052.regcon)
		ac:SetOperation(c511002052.regop)
		Duel.RegisterEffect(ac,0)
	end)
end
-----register------------------------------------
function c511002052.regcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if p==1-tp or (g and g:GetFirst():IsControler(1-tp)) then return false end
	return re and re:IsActiveType(TYPE_SPELL) and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler()~=e:GetHandler() 
end
function c511002052.regop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	rc:RegisterFlagEffect(511002052,nil,0,0,1)
end
-----Change the effect flag player---------------------------
function c511002052.condition(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	if p~=tp then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET)
end
function c511002052.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local te=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		local ftg=te:GetTarget()
		return ftg==nil or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c511002052.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	Duel.ChangeTargetPlayer(ev,1-p)
end
-----Reflect spell-----------------------------------------
function c511002052.chcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	if p==1-tp then return false end
	return re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) and not (re:IsHasProperty(EFFECT_FLAG_PLAYER_TARGET) 
	or re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) or re:IsHasCategory(CATEGORY_SUMMON) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)) 
end
function c511002052.chop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if op then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,c511002052.repop(tp,op))
	end	
end
function c511002052.repop(tp,op)
	return function(e,tp,eg,ep,ev,re,r,rp)
		op(e,1-tp,eg,ep,ev,re,r,rp)
	end
end
-----Change the effect target---------------------------
function c511002052.efcon(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasCategory(CATEGORY_SUMMON) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON)  
	or not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_SPELL) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end	
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g then return false end
	local tc=g:GetFirst()
	return tc:IsLocation(LOCATION_ONFIELD) and tc:IsControler(tp)
end
function c511002052.tcfilter(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c511002052.eftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local tf=re:GetTarget()
	local res,ceg,cep,cev,cre,cr,crp=Duel.CheckEvent(re:GetCode(),true)
	if chkc then return chkc~=e:GetLabelObject() and chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and tf(re,rp,ceg,cep,cev,cre,cr,crp,0,chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511002052.tcfilter,tp,0,LOCATION_ONFIELD,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c511002052.tcfilter,tp,0,LOCATION_ONFIELD,1,1,e:GetLabelObject(),re,rp,tf,ceg,cep,cev,cre,cr,crp)
end
function c511002052.efop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if g:GetFirst():IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,g)
	end
end
------Reflect Summon-----------------------------------
function c511002052.sumcon(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(ev,CHAININFO_TARGET_PLAYER)
	if p==1-tp then return false end
	return ep==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:IsActiveType(TYPE_SPELL) 
		and (re:IsHasCategory(CATEGORY_SUMMON) or re:IsHasCategory(CATEGORY_SPECIAL_SUMMON))
end
function c511002052.sumop(e,tp,eg,ep,ev,re,r,rp)
	local op=re:GetOperation()
	if op then
		Duel.ChangeChainOperation(ev,c511002052.repop(tp,op))	
	end
end
-----Copy Spell------------------------------------
function c511002052.egcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c511002052.cffilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,e:GetHandler())
end
function c511002052.cffilter(c)
	if c:GetFlagEffect(511002052)==0 then return false end
	return not c:IsHasEffect(511001408) and not c:IsHasEffect(511001283) and c511002052.ffilter2(c) and not c:IsStatus(STATUS_CHAINING)	
end
function c511002052.ffilter2(c,e,tp)
	local te=c:GetActivateEffect()
	if c:IsHasEffect(EFFECT_CANNOT_TRIGGER) or c:GetFlagEffect(511002052)==0 then return false end
	local pre={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
	if pre[1] then
		for i,eff in ipairs(pre) do
			local prev=eff:GetValue()
			if type(prev)~='function' or prev(eff,te,tp) then return false end
		end
	end
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if c:IsLocation(LOCATION_HAND) then
		ft=ft-1
	end
	return c:IsType(TYPE_SPELL) and c:CheckActivateEffect(false,false,false)~=nil and ft>0
end
function c511002052.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD+LOCATION_GRAVE) end
	if chk==0 then return Duel.IsExistingTarget(c511002052.cffilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,0,1,e:GetHandler())
	or Duel.IsExistingTarget(c511002052.cffilter,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=Duel.SelectTarget(tp,c511002052.cffilter,tp,LOCATION_GRAVE+LOCATION_ONFIELD,LOCATION_GRAVE+LOCATION_ONFIELD,1,1,e:GetHandler())
end
function c511002052.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+RESET_CHAIN+PHASE_END)
	tc:RegisterEffect(e1)
	if c:IsRelateToEffect(e) and not tc:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) then
		local tpe=tc:GetType()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(tpe)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		c:RegisterEffect(e1)
		local te=tc:GetActivateEffect()
		local co=te:GetCost()
		local tg=te:GetTarget()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		Duel.ClearTargetCard()
		if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		Duel.BreakEffect()
		if op then op(e,tp,eg,ep,ev,re,r,rp) end 
	end
	if c:IsRelateToEffect(e) and tc:IsType(TYPE_EQUIP+TYPE_CONTINUOUS) or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
		local tpe=tc:GetType()
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_CHANGE_TYPE)
		e3:SetValue(tpe)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e3)
		if tc:IsType(TYPE_PENDULUM) then
			local token=Duel.CreateToken(tc:GetOwner(),tc:GetOriginalCode())
			Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			Duel.SendtoDeck(tc,nil,-2,REASON_EFFECT)
			Duel.Hint(HINT_CARD,0,tc:GetCode())
			tc:CreateEffectRelation(te)
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
			if op then op(te,tp,eg,ep,ev,re,r,rp) end
			Duel.BreakEffect()
			local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
			if g then
				local etc=g:GetFirst()
				while etc do
					etc:CreateEffectRelation(te)
					etc=g:GetNext()
				end
			end
		if op then op(te,tp,eg,ep,ev,re,r,rp) end
		else
			local tpe=tc:GetType()
			if (tpe&TYPE_FIELD)~=0 then
				local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
				if of then Duel.Destroy(of,REASON_RULE) end
				of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			if (tpe&TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD) or tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
				tc:CancelToGrave() end	
		end		
	end
end
