--デルタフライ
function c120000348.initial_effect(c)
	--lvchange
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000348,0))
	e1:SetCategory(CATEGORY_LVCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c120000348.lvtg)
	e1:SetOperation(c120000348.lvop)
	c:RegisterEffect(e1)
end
function c120000348.filter(c)
	return c:IsFaceup() and not c:IsType(TYPE_XYZ)
end
function c120000348.lvtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000348.filter(chkc) end
	if chk==0 then return e:GetHandler():IsType(TYPE_MONSTER) 
		and Duel.IsExistingTarget(c120000348.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000348.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
end
function c120000348.lvop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(120000348,0))
		local op=Duel.SelectOption(tp,aux.Stringid(120000348,1),aux.Stringid(120000348,2))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if op==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
	end
end