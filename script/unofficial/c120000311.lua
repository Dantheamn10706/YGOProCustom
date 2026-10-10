--EMウィップ・バイパー
function c120000311.initial_effect(c)
	--swap
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000311,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1)
	e1:SetTarget(c120000311.target)
	e1:SetOperation(c120000311.operation)
	c:RegisterEffect(e1)
end
function c120000311.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c120000311.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_ONFIELD) and c120000311.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000311.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000311.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c120000311.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local def=tc:GetDefense()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SWAP_ATTACK_FINAL)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(def)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SWAP_DEFENSE_FINAL)
		e2:SetValue(atk)
		tc:RegisterEffect(e2)
	end
end
