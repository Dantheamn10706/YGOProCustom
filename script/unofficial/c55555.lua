local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.spcon1)
	e1:SetTarget(s.sptg1)
	e1:SetOperation(s.spop1)
	c:RegisterEffect(e1)
	--ATK gain
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(s.atkval)
	c:RegisterEffect(e2)
	--Special summon Synchro dragon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER_E)
	e3:SetCountLimit(1,{id,1})
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end
	function s.spfilter1(c,att)
	return c:IsType(TYPE_SYNCHRO) and c:IsAbleToRemoveAsCost()and not c:IsCode(id)
	
end
function s.spcon1(e,c)
	if c==nil then return true end
	if Duel.GetLP(Duel.GetTurnPlayer())<=1000 and Duel.IsExistingMatchingCard(s.atkfilter,0,LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,0) then
	local tp=e:GetHandlerPlayer()
	local rg1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local rg2=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local rg3=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local rg4=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local rg5=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local rg=rg1:Clone()
	rg:Merge(rg2)
	rg:Merge(rg3)
	rg:Merge(rg4)
	rg:Merge(rg5)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-5 and #rg1>0 and #rg2>0 and #rg3>0 and #rg4>0 and #rg5>0 and aux.SelectUnselectGroup(rg,e,tp,5,5,s.rescon,0)
	end
end
function s.sptg1(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	local g=nil
	local rg=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_MZONE+LOCATION_EXTRA,0,nil)
	local g=aux.SelectUnselectGroup(rg,e,tp,5,5,s.rescon,1,tp,HINTMSG_REMOVE,nil,nil,true)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end
function s.spop1(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	if not g then return end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
	g:DeleteGroup()
end
function s.atkfilter(c)
	return (c:IsSetCard(0xc2) or ((c:GetLevel()>6) and c:IsRace(RACE_DRAGON)))
		and c:IsType(TYPE_SYNCHRO) and not c:IsCode(id)
end
function s.atkval(e,c)
	local g=Duel.GetMatchingGroup(s.atkfilter,c:GetControler(),LOCATION_GRAVE,0,c)
	return g:GetSum(Card.GetAttack)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.atkfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.atkfilter),tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,SUMMON_TYPE_SYNCHRO,tp,tp,false,false,POS_FACEUP)
		
	end
end