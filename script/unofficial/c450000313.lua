--グランエルＧ３ 
function c450000313.initial_effect(c)
	--Selfdes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SELF_DESTROY)
	e1:SetCondition(c450000313.sdcon)
	c:RegisterEffect(e1)
	--Special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c450000313.spcon)
	e2:SetOperation(c450000313.spop)
	c:RegisterEffect(e2)
	--Change battle target
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21558682,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BE_BATTLE_TARGET)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCondition(c450000313.cbcon)
	e3:SetTarget(c450000313.cbtg)
	e3:SetOperation(c450000313.cbop)
	c:RegisterEffect(e3)
	--Negate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(23274061,0))
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetCondition(c450000313.negcon)
	e4:SetTarget(c450000313.negtg)
	e4:SetOperation(c450000313.negop)
	c:RegisterEffect(e4)
end
function c450000313.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and (c:IsSetCard(0x3013)) 
end
function c450000313.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsExistingMatchingCard(c450000313.cfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) and not e:GetHandler():IsCode(63468625)
end
function c450000313.spfilter(c,code)
	return c:GetCode()==code
end
function c450000313.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.CheckReleaseGroup(tp,c450000313.spfilter,1,nil,100000064)
end
function c450000313.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectReleaseGroup(tp,c450000313.spfilter,1,1,nil,100000064)
	Duel.Release(g1,REASON_COST)
end
function c450000313.cfilter(c)
	return c:IsFaceup() and ( c:IsSetCard(0x3013) or c:IsCode(63468625) ) 
end
function c450000313.cbcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return e:GetHandler():IsType(TYPE_MONSTER) and d and d:IsFaceup() and d:IsControler(tp) and d:IsSetCard(0x3013) or d:IsCode(63468625) 
	and d:GetEquipCount()~=0 and d:GetEquipGroup():IsExists(Card.IsType,1,nil,TYPE_SYNCHRO)
end
function c450000313.tgfilter(c)
	local ec=c:GetEquipTarget()
	return c:IsType(TYPE_SYNCHRO) and (ec:IsSetCard(0x3013) or ec:IsCode(63468625))
end
function c450000313.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c450000312.tgfilter,tp,LOCATION_SZONE,0,1,1,nil)
end
function c450000313.cbop(e,tp,eg,ep,ev,re,r,rp)
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
function c450000313.negcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and e:GetHandler():IsType(TYPE_MONSTER) and ep~=tp
		and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c450000313.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function c450000313.negop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
