--ディメンション・ガーディアン
function c120000278.initial_effect(c)
	aux.AddPersistentProcedure(c,0,aux.FilterBoolFunction(Card.IsPosition,POS_FACEUP_ATTACK))
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetRange(LOCATION_SZONE)
	e1:SetValue(1)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c120000278.indescon)
	e1:SetTarget(aux.PersistentTargetFilter)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c120000278.descon)
	e2:SetOperation(c120000278.desop)
	c:RegisterEffect(e2)
end
function c120000278.indescon(e)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc:IsAttackPos()
end
function c120000278.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c120000278.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
