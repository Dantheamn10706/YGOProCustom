--ドラゴン族・封印の壺
function c120000022.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c120000022.target)
	e1:SetOperation(c120000022.activate)
	c:RegisterEffect(e1)
end
function c120000022.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) 
		and Duel.IsPlayerCanSpecialSummonMonster(tp,120000022,0,0x11,100,200,2,RACE_ROCK,ATTRIBUTE_EARTH) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000022.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		or not Duel.IsPlayerCanSpecialSummonMonster(tp,120000022,0,0x11,100,200,2,RACE_ROCK,ATTRIBUTE_EARTH) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)
	c:AddMonsterAttributeComplete()
	--Attach
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)	
	e1:SetCountLimit(1)
	e1:SetTarget(c120000022.attg)
	e1:SetOperation(c120000022.atop)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e1)
	--Def
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(c120000022.val)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c120000022.filter(c)
	return c:IsRace(RACE_DRAGON) and c:IsFaceup() and not c:IsCode(50045299)
end
function c120000022.attg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c120000022.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,g:GetCount(),0,0)
end
function c120000022.atop(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetMatchingGroup(c120000022.filter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Overlay(e:GetHandler(),tg)
end
function c120000022.val(e,c)
	local c=e:GetHandler()
	local g=c:GetOverlayGroup()
	local def=0
	local val=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsType(TYPE_MONSTER) then
			def=tc:GetDefense()
		else
			def=0
		end
		val=val+def
		tc=g:GetNext()
	end
	return val
end	
