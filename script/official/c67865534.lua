--希望の魔術師
--Magician of Hope
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon procedure: 2 Level 4 monsters
	Xyz.AddProcedure(c,nil,4,2)
	--Pendulum Summon procedure
	Pendulum.AddProcedure(c,false)
	--Negate an attack, then destroy this card
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetTarget(s.atktg)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)
	--Special Summon 1 Level 7 or lower Pendulum Monster from your hand then you can place this face-up card in your Pendulum Zone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(Cost.DetachFromSelf(1))
	e2:SetTarget(s.sptg)
	e2:SetOperation(s.spop)
	c:RegisterEffect(e2)
	--Attach 1 Pendulum Monster in your GY to this card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(function(e) return e:GetHandler():IsPendulumSummoned() end)
	e3:SetTarget(s.xyztg)
	e3:SetOperation(s.xyzop)
	c:RegisterEffect(e3)
end
s.pendulum_level=4
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler(),1,0,0)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.NegateAttack() then
		Duel.BreakEffect()
		Duel.Destroy(c,REASON_EFFECT)
	end
end
function s.spfilter(c,e,tp)
	return c:IsType(TYPE_PENDULUM) and c:IsLevelBelow(7) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp):GetFirst()
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD)
		tc:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc:RegisterEffect(e2)
		if c:IsType(TYPE_PENDULUM) and Duel.CheckPendulumZones(tp) and c:IsRelateToEffect(e)
			and c:IsFaceup() and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
		end
	end
end
function s.xyzfilter(c,tp,xyzc)
	return c:IsType(TYPE_PENDULUM) and c:IsMonster() and c:IsCanBeXyzMaterial(xyzc,tp,REASON_EFFECT)
end
function s.xyztg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and s.xyzfilter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(s.xyzfilter,tp,LOCATION_GRAVE,0,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTACH)
	local g=Duel.SelectTarget(tp,s.xyzfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,0)
end
function s.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Overlay(c,tc)
	end
end
