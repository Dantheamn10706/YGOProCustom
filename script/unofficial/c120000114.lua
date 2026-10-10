--サウザンド・クロス
function c120000114.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x20018)
	e1:SetLabel(3)
	c:RegisterEffect(e1)
	--gains lp
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_RECOVER)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabelObject(e1)
	e2:SetCondition(c120000114.lpgcon)
	e2:SetOperation(c120000114.lpop)
	c:RegisterEffect(e2)
	--loses lp
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_DAMAGE)
	e3:SetRange(LOCATION_SZONE)
	e3:SetLabelObject(e1)
	e3:SetCondition(c120000114.lplcon)
	e3:SetOperation(c120000114.lpop)
	c:RegisterEffect(e3)
end
function c120000114.lpgcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c120000114.lplcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c120000114.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetLP(tp,1000,REASON_EFFECT)
	local ct=e:GetLabelObject():GetLabel()
	ct=ct-1
	e:GetLabelObject():SetLabel(ct)
	if ct<=0 then
		Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	end
end
