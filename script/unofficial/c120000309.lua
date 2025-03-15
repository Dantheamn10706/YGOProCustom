--ブラックフェザー・ドラゴン
function c120000309.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	c:EnableReviveLimit()
	--damage reduce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(1,0)
	e1:SetValue(c120000309.damval)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000309,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetLabel(0)
	e2:SetLabelObject(e1)
	e2:SetOperation(c120000309.operation)
	c:RegisterEffect(e2)
end
function c120000309.damval(e,re,val,r,rp,rc)
	if bit.band(r,REASON_EFFECT)~=0 then
		e:SetLabel(val)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-val)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e1)
		return 0
	end
	return val
end
function c120000309.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c120000309.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=c:GetAttack()
	local val=e:GetLabelObject():GetLabel()
	if atk<val then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(val)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	if c:RegisterEffect(e1) then
		local g=Duel.GetMatchingGroup(c120000309.filter,tp,0,LOCATION_ONFIELD,nil)
		if g:GetCount()==0 then return end
		local tc=g:GetFirst()
		while tc do
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_UPDATE_ATTACK)
			e2:SetValue(-val)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		end
	end
end
