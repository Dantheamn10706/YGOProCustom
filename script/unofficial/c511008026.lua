--グランエルＴ５
function c511008026.initial_effect(c)
	--selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c511008026.sdcon)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCondition(c511008026.eqcon)
	e2:SetOperation(c511008026.eqop)
	c:RegisterEffect(e2)
end
function c511008026.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsSetCard(0x3013)) 
end
function c511008026.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c511008026.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and not e:GetHandler():IsCode(63468625)
end
function c511008026.eqfil1(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function c511008026.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingTarget(c511008026.eqfil1,tp,0,LOCATION_MZONE,1,nil)
	and Duel.IsExistingTarget(c511008026.cfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
end
function c511008026.eqop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local eqg=Duel.SelectMatchingCard(tp,c511008026.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local eqtgc=Duel.SelectMatchingCard(tp,c511008026.eqfil1,tp,0,LOCATION_MZONE,1,1,nil)
	if not eqg or not eqtgc then return end
	local eqc=eqg:GetFirst()
	local eqtg=eqtgc:GetFirst()
	if eqtg:IsFaceup() and eqtg:IsType(TYPE_MONSTER) and not eqtg:IsType(TYPE_EFFECT) then
		if eqc:IsFaceup() then
			if not Duel.Equip(tp,eqtg,eqc,false) then return end
			--add equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c511008026.eqlimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			eqtg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetValue(TYPE_SYNCHRO+TYPE_MONSTER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			eqtg:RegisterEffect(e2)
		else Duel.SendtoGrave(eqtg,REASON_EFFECT) end	
	elseif eqtg:IsFaceup() and eqtg:IsType(TYPE_MONSTER) and eqtg:IsType(TYPE_EFFECT) then
		if eqc:IsFaceup() then
			if not Duel.Equip(tp,eqtg,eqc,false) then return end
			--add equip limit
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetValue(c511008026.eqlimit)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			eqtg:RegisterEffect(e1)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetValue(TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			eqtg:RegisterEffect(e2)		
		else Duel.SendtoGrave(eqtg,REASON_EFFECT) end
	end
end
function c511008026.eqlimit(e,c)
	return not c:IsDisabled()
end