--ものマネ幻想師
function c511002387.initial_effect(c)
	--set
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MONSTER_SSET)
	e0:SetValue(TYPE_SPELL)
	c:RegisterEffect(e0)
	--Copy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(84565800,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511002387.target)
	e1:SetOperation(c511002387.activate)
	c:RegisterEffect(e1)
end
function c511002387.filter(c,e,tp,eg,ep,ev,re,r,rp)
	local te=c:GetActivateEffect()
		if not te then return false end
		local cost=te:GetCost()
		local target=te:GetTarget()
		return c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP) and (not cost or cost(te,tp,eg,ep,ev,re,r,rp,0)) and (not target or target(te,tp,eg,ep,ev,re,r,rp,0))
end
function c511002387.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and c511002387.filter(chkc,e,tp,eg,ep,ev,re,r,rp) end
	if chk==0 then return Duel.IsExistingTarget(c511002387.filter,tp,0,LOCATION_GRAVE,1,nil,e,tp,eg,ep,ev,re,r,rp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local g=Duel.SelectTarget(tp,c511002387.filter,tp,0,LOCATION_GRAVE,1,1,nil)
	local code=g:GetFirst():GetOriginalCode()
	e:SetLabel(code)
end
function c511002387.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
	if tc:IsType(TYPE_MONSTER) then return end
		local te=tc:GetActivateEffect()
		if not te then return end
		local tpe=tc:GetType()
		local code=e:GetLabel()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetValue(tpe)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_CHANGE_CODE)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		e2:SetValue(code)
		c:RegisterEffect(e2)
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local of=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if of then Duel.Destroy(of,REASON_RULE) end
			of=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
			if of and Duel.Destroy(of,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			Duel.MoveSequence(c,5)
		end
		Duel.ClearTargetCard()
		local tg=te:GetTarget()
		local co=te:GetCost()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
		if tg then tg(e,tp,eg,ep,ev,re,r,rp,1) end
		if co then co(e,tp,eg,ep,ev,re,r,rp,1) end
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 then
			c:CancelToGrave(false)
		else
			c:CancelToGrave(true)
			local code=te:GetHandler():GetOriginalCode()
			c:CopyEffect(code,RESET_EVENT+0x1fe0000)
		end
		local op=te:GetOperation()
		if op then op(e,tp,eg,ep,ev,re,r,rp)
	end
end
