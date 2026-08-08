--グランエルＧ 
function c450000309.initial_effect(c)
	--Selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c450000309.sdcon)
	c:RegisterEffect(e1)
	--Change battle target
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21558682,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c450000309.cbcon)
	e2:SetTarget(c450000309.cbtg)
	e2:SetOperation(c450000309.cbop)
	c:RegisterEffect(e2)
end
c450000309[0]=0
function c450000309.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsSetCard(0x3013) or c:IsCode(63468625)) 
end
function c450000309.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsType(TYPE_MONSTER) and not Duel.IsExistingMatchingCard(c450000309.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,c) and not c:IsCode(63468625)
end
function c450000309.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return e:GetHandler():IsType(TYPE_MONSTER) and d and d:IsFaceup() and d:IsControler(tp) and d:IsSetCard(0x3013) or d:IsCode(63468625)
end
function c450000309.tgfilter(c)
	local ec=c:GetEquipTarget()
	return c:IsType(TYPE_SYNCHRO) and (ec:IsSetCard(0x3013) or ec:IsCode(63468625))
end
function c450000309.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c450000309.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c450000309.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if c:IsFaceup() and tc and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(tc:GetTextAttack())
		e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
		c:RegisterEffect(e1)
		Duel.ChangeAttackTarget(e:GetHandler())
	end
end
