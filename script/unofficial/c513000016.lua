--王家の神殿
function c513000016.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Trap activate in set turn
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_SZONE,0)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5012,14))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c513000016.rmcon)
	e3:SetTarget(c513000016.rmtg)
	e3:SetOperation(c513000016.rmop)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(5012,15))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_SZONE)
	e4:SetLabelObject(e3)
	e4:SetCost(c513000016.cost)
	e4:SetTarget(c513000016.target)
	e4:SetOperation(c513000016.operation)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_SZONE)
	e5:SetTargetRange(0,1)
	e5:SetCondition(c513000016.econ)
	e5:SetValue(c513000016.elimit)
	c:RegisterEffect(e5)
	aux.GlobalCheck(c513000016,function()
		c513000016[0]=0
		c513000016[1]=0
		--activate limit
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetRange(LOCATION_MZONE)
		ge1:SetOperation(c513000016.aclimit1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge2:SetCode(EVENT_CHAIN_NEGATED)
		ge2:SetRange(LOCATION_MZONE)
		ge2:SetOperation(c513000016.aclimit2)
		Duel.RegisterEffect(ge2,0)
		local ge3=Effect.CreateEffect(c)
		ge3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCountLimit(1)
		ge3:SetOperation(c513000016.clear)
		Duel.RegisterEffect(ge3,0)
	end)
end
function c513000016.rmcon(e)
	return e:GetHandler():GetFlagEffect(513000016)==0
end
function c513000016.rmfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemove()
end
function c513000016.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c513000016.rmfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_HAND)
end
function c513000016.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c513000016.rmfilter,tp,LOCATION_HAND,0,1,1,nil)
	e:SetLabelObject(g:GetFirst())
	local tc=g:GetFirst()
	if tc and e:GetHandler():IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEDOWN,REASON_EFFECT) then
		--forbidden
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(c513000016.efilterx)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetCode(EFFECT_SEND_REPLACE)
		e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e2:SetRange(LOCATION_MZONE)
		e2:SetTarget(c513000016.reptg)
		e2:SetValue(function(e,c) return false end)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2)
		e:GetHandler():RegisterFlagEffect(513000016,RESET_EVENT+0x7e0000,0,0)
		tc:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD,0,0)
	end
end
function c513000016.efilterx(e,te)
	if not te then return false end
	return te:IsHasCategory(CATEGORY_TOHAND+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_TODECK+CATEGORY_RELEASE+CATEGORY_TOGRAVE+CATEGORY_FUSION_SUMMON)
	and not te:GetCode()==29762407
end
function c513000016.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and e:GetHandler():IsReason(REASON_EFFECT) and r&REASON_EFFECT~=0 end
	return true
end
function c513000016.cfilter2(c)
	return c:IsType(TYPE_MONSTER) 
end
function c513000016.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c513000016.cfilter2,tp,LOCATION_ONFIELD,0,1,nil) and e:GetHandler():GetFlagEffect(513000016)~=0 end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
	local sg=Duel.SelectReleaseGroup(tp,c513000016.cfilter2,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
function c513000016.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1 and Duel.IsPlayerCanSpecialSummon(tp) end
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and tc:GetFlagEffect(id)~=0 then
		Duel.SetTargetCard(tc)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
	end
end
function c513000016.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 or not Duel.IsPlayerCanSpecialSummon(tp) then return end
	local tc=Duel.GetFirstTarget()
	local tc=e:GetLabelObject():GetLabelObject()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
		e:GetHandler():ResetFlagEffect(513000016)
	end
end
function c513000016.aclimit1(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	c513000016[ep]=c513000016[ep]+1
end
function c513000016.aclimit2(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) then return end
	c513000016[ep]=c513000016[ep]-1
end
function c513000016.clear(e,tp,eg,ep,ev,re,r,rp)
	c513000016[0]=0
	c513000016[1]=0
end
function c513000016.econ(e)
	return c513000016[1-e:GetHandlerPlayer()]>=2
end
function c513000016.elimit(e,te,tp)
	return te:IsHasType(EFFECT_TYPE_ACTIVATE)
end