--DDD狙撃王テル
function c120000368.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,5,2)
	c:EnableReviveLimit()
	--lose atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000368,0))
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c120000368.condition)
	e1:SetCost(c120000368.cost)
	e1:SetTarget(c120000368.target)
	e1:SetOperation(c120000368.operation)
	c:RegisterEffect(e1,false,1)
	if not c120000368.global_check then
		c120000368.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c120000368.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c120000368.checkop(e,tp,eg,ep,ev,re,r,rp)
	if bit.band(r,REASON_EFFECT)~=0 and ep==tp and re:GetHandler():IsSetCard(0xae) then
		Duel.RegisterFlagEffect(ep,120000368,RESET_PHASE+PHASE_END,0,1)
	end
end	
function c120000368.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,120000368)~=0 and (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated())
end
function c120000368.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c120000368.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER)
end
function c120000368.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(c120000368.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,c120000368.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1000)
end
function c120000368.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() and not tc:IsImmuneToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-1000)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		Duel.Damage(1-tp,1000,REASON_EFFECT)
	end
end