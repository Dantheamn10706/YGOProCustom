--H・C スパルタス
function c120000182.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000182,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetCondition(c120000182.atkcon)
	e1:SetOperation(c120000182.atkop)
	c:RegisterEffect(e1)
end
function c120000182.atkfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and c:GetBaseAttack()>0 and c:IsCode(50491121)
end
function c120000182.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local at=Duel.GetAttacker()
	return at and at:GetControler()~=tp and Duel.IsExistingMatchingCard(c120000182.atkfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) 
	and not e:GetHandler():IsStatus(STATUS_CHAINING) 
end
function c120000182.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local g=Duel.GetMatchingGroup(c120000182.atkfilter,c:GetControler(),LOCATION_ONFIELD,0,c)
		local atk=g:GetSum(Card.GetBaseAttack)
		if atk>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(atk)
			e1:SetReset(RESET_EVENT+0x1ff0000)
			c:RegisterEffect(e1)
		end	
	end		
end

