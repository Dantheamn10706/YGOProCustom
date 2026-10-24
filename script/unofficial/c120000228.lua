--暴風雨
function c120000228.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000228,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c120000228.target)
	e1:SetOperation(c120000228.activate)
	c:RegisterEffect(e1)
end
function c120000228.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x18) and c:IsAttackAbove(1000)
end
function c120000228.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000228.cfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000228.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000228.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c120000228.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local atk=tc:GetAttack()
		local t={}
		local f=math.floor((atk)/1000)
		local l=1
		while l<=f and l<=20 do
		t[l]=l*1000
		l=l+1
	end
		local announce=Duel.AnnounceNumber(tp,table.unpack(t))
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-announce)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
		local ct=announce/1000
		local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
		local dg=g:Select(tp,ct,ct,nil)
		Duel.Destroy(dg,REASON_EFFECT)
	end
end		