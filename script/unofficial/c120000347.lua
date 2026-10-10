--ライライダー
function c120000347.initial_effect(c)
	--atk limit
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000347,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(c120000347.condition)
	e1:SetOperation(c120000347.activate)
	c:RegisterEffect(e1)
end
function c120000347.condition(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	return tc and not tc:IsStatus(STATUS_BATTLE_DESTROYED)
end
function c120000347.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetBattleTarget()
	--cannot attack
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetLabelObject(tc)
	e1:SetCondition(c120000347.con)
	e1:SetOperation(c120000347.op)
	if Duel.GetTurnPlayer()~=tp then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	else
		e1:SetLabel(0)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
	Duel.RegisterEffect(e1,tp)
end
function c120000347.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel() 
end
function c120000347.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end