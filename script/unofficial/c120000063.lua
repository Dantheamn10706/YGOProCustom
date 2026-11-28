--マジック・ランプ
function c120000063.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000063,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCondition(c120000063.condition)
	e1:SetTarget(c120000063.target)
	e1:SetOperation(c120000063.activate)
	c:RegisterEffect(e1)
	--change target2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000063,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c120000063.condition)
	e2:SetTarget(c120000063.target1)
	e2:SetOperation(c120000063.operation)
	c:RegisterEffect(e2)
end
function c120000063.cfilter(c)
	return c:IsFaceup() and c:IsCode(97590747)
end
function c120000063.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bt=eg:GetFirst()
	return Duel.IsExistingMatchingCard(c120000063.cfilter,tp,LOCATION_ONFIELD,0,1,nil) and bt:GetControler()==c:GetControler()
end
function c120000063.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and 
		Duel.IsPlayerCanSpecialSummonMonster(tp,120000063,0,0x21,900,1400,3,RACE_SPELLCASTER,ATTRIBUTE_WIND) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000063.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetAttacker()
	if not c:IsRelateToEffect(e) and not a:IsImmuneToEffect(e) then return end
	if tc and tc:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 and a:IsAttackable() 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,120000063,0,0x21,900,1400,3,RACE_SPELLCASTER,ATTRIBUTE_WIND) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummonStep(c,0,tp,tp,true,false,POS_FACEUP_DEFENSE)
	c:AddMonsterAttributeComplete()
	Duel.SpecialSummonComplete()
	Duel.CalculateDamage(a,tc)
end
function c120000063.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,Duel.GetAttacker())
end
function c120000063.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local a=Duel.GetAttacker()
	if tc and tc:IsRelateToEffect(e)
		and a:IsAttackable() and not a:IsImmuneToEffect(e) then
		Duel.CalculateDamage(a,tc)
	end
end
