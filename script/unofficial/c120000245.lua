--スターフィッシュ
function c120000245.initial_effect(c)
	--lv change
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000245,0))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000245.condition)
	e1:SetOperation(c120000245.activate)
	c:RegisterEffect(e1)
end
function c120000245.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:IsCode(44717069)
end
function c120000245.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c120000245.filter,tp,LOCATION_ONFIELD,0,e:GetHandler())>0
end
function c120000245.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ct=Duel.GetMatchingGroupCount(c120000245.filter,tp,LOCATION_ONFIELD,0,c)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000245,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(ct)
	e2:SetTarget(c120000245.lvtg)
	e2:SetOperation(c120000245.lvop)
	e2:SetReset(RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
end
function c120000245.lvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EFFECT)
	local op=Duel.SelectOption(tp,aux.Stringid(120000245,1),aux.Stringid(120000245,2))
	e:SetLabel(op)
end
function c120000245.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		if e:GetLabel()==0 then
			e1:SetValue(1)
		else
			e1:SetValue(-1)
		end
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
	end
	Duel.Readjust()
end