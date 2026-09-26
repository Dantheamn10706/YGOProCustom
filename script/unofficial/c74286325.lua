--Diabound Evolved
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Cannot be Normal Summoned/Set. Must first be Special Summoned (from hand) by
	--sending 1 "Diabound Kernel" from your hand, field, or Deck to the GY.
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.spcon)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	--At the end of the Damage Step, if this card destroyed an opponent's monster by
	--battle: this card gains ATK equal to half that monster's original ATK.
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYING)
	e2:SetCondition(s.atkcon)
	e2:SetOperation(s.atkop)
	c:RegisterEffect(e2)
	--Once per turn: banish 1 Effect Monster from either GY; until the end of this turn,
	--this card's effects are also treated as that banished monster's effects.
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(s.cptg)
	e3:SetOperation(s.cpop)
	c:RegisterEffect(e3)
end
s.listed_names={51644030,511000118}
--Special Summon procedure
function s.cfilter(c)
	return c:IsCode(51644030,511000118) and c:IsAbleToGraveAsCost()
end
function s.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,nil)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_DECK,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
--ATK gain on battle destruction
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsControler(1-tp) and bc:IsType(TYPE_MONSTER) then
		local half=bc:GetBaseAttack()//2
		if half<0 then half=0 end
		e:SetLabel(half)
		return true
	end
	e:SetLabel(0)
	return false
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=e:GetLabel()
	if val>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end
--Banish an Effect Monster from either GY and copy its effects until the End Phase
function s.cpfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT) and c:IsAbleToRemove()
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and s.cpfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,s.cpfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and c:IsFaceup() and c:IsRelateToEffect(e) then
		local code=tc:GetOriginalCode()
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			c:CopyEffect(code,RESETS_STANDARD_PHASE_END,1)
		end
	end
end
