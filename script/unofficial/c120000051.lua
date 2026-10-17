--光子化
function c120000051.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetDescription(aux.Stringid(120000051,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMING_BATTLE_PHASE)
	e1:SetCondition(c120000051.condition)
	e1:SetTarget(c120000051.target)
	e1:SetOperation(c120000051.activate)
	c:RegisterEffect(e1)
end
function c120000051.condition(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return (a and a:IsControler(1-tp) and a:IsFaceup())
end
function c120000051.filter(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function c120000051.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c120000051.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c120000051.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c120000051.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
	local at=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(at:GetAttack())
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
end
