--契約洗浄
function c120000370.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000370,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000370.condition)
	e1:SetTarget(c120000370.target)
	e1:SetOperation(c120000370.activate)
	c:RegisterEffect(e1)
	if not c120000370.global_check then
		c120000370.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c120000370.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c120000370.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and re:GetHandler():IsSetCard(0xae) then
		Duel.RegisterFlagEffect(ep,120000370,RESET_PHASE+PHASE_END,0,1)
	end
end	
function c120000370.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,120000370)~=0 
end
function c120000370.filter(c)
	return c:IsFaceup() and c:IsSetCard(0xae) and c:GetSequence()<5
end
function c120000370.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000370.filter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c120000370.filter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,g,g:GetCount(),0,0)
end
function c120000370.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000370.filter,tp,LOCATION_SZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		--disable
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetValue(RESET_TURN_SET)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	tc=g:GetNext()
	end
	--destroy
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetDescription(aux.Stringid(120000370,1))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DRAW)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetCountLimit(1)
	e3:SetTarget(c120000370.destg)
	e3:SetOperation(c120000370.desop)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e3,tp)
end
function c120000370.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp) and Duel.IsExistingMatchingCard(c120000370.filter,tp,LOCATION_SZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c120000370.filter,tp,LOCATION_SZONE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,g:GetCount())
end
function c120000370.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000370.filter,tp,LOCATION_SZONE,0,nil)
	local ct1=Duel.Destroy(g,REASON_EFFECT)
	if ct1==0 then return end
	local ct2=Duel.Draw(tp,ct1,REASON_EFFECT)
end