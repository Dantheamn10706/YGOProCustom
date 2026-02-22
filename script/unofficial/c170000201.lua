--Legend of Heart
function c170000201.initial_effect(c)
    --Activate
    local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCost(c170000201.cost)
    e1:SetTarget(c170000201.sptg)
    e1:SetOperation(c170000201.spop)
	c:RegisterEffect(e1)
end
function c170000201.costfilter(c,code)
	return c:IsCode(code) and c:IsAbleToRemoveAsCost()
end
function c170000201.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.CheckLPCost(tp,1000) and Duel.CheckReleaseGroup(tp,Card.IsRace,1,nil,RACE_WARRIOR) 
    	and Duel.IsExistingMatchingCard(c170000201.costfilter,tp,0x1f,0,1,nil,1784686)
 		and Duel.IsExistingMatchingCard(c170000201.costfilter,tp,0x1f,0,1,nil,46232525)
		and Duel.IsExistingMatchingCard(c170000201.costfilter,tp,0x1f,0,1,nil,11082056) end
    Duel.PayLPCost(tp,1000)
	local rg=Duel.SelectReleaseGroup(tp,Card.IsRace,1,1,nil,RACE_WARRIOR)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g1=Duel.SelectMatchingCard(tp,c170000201.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil,1784686)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectMatchingCard(tp,c170000201.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil,11082056)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g3=Duel.SelectMatchingCard(tp,c170000201.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND+LOCATION_DECK+LOCATION_ONFIELD,0,1,1,nil,46232525)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.Remove(g1,POS_FACEUP,REASON_COST)
	Duel.Release(rg,REASON_COST)
end
function c170000201.spfilter(c,e,tp,code)
	return c:IsCode(code) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c170000201.filter(c)
	return c:IsCode(48179391) or c:IsCode(110000100) or c:IsCode(110000101)
end
function c170000201.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function c170000201.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,80019195,0,0x4011,2800,200,8,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,80019195)
		Duel.SpecialSummonStep(token,0,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(170000201,0))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c170000201.ncondition)
		e1:SetOperation(c170000201.noperation)
		e1:SetCountLimit(1)
		token:RegisterEffect(e1)
		local e01=Effect.CreateEffect(e:GetHandler())
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e01:SetValue(1)
		token:RegisterEffect(e01,true)			
	end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,85800949,0,0x4011,2800,200,8,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,85800949)
		Duel.SpecialSummonStep(token,0,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(170000201,0))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c170000201.ncondition)
		e1:SetOperation(c170000201.noperation)
		e1:SetCountLimit(1)
		token:RegisterEffect(e1)
		local e01=Effect.CreateEffect(e:GetHandler())
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e01:SetValue(1)
		token:RegisterEffect(e01,true)			
	end
		if Duel.IsPlayerCanSpecialSummonMonster(tp,84565800,0,0x4011,2800,200,8,RACE_WARRIOR,ATTRIBUTE_LIGHT) then
		local token=Duel.CreateToken(tp,84565800)
		Duel.SpecialSummonStep(token,0,tp,tp,true,true,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(170000201,0))
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(c170000201.ncondition)
		e1:SetOperation(c170000201.noperation)
		e1:SetCountLimit(1)
		token:RegisterEffect(e1)
		local e01=Effect.CreateEffect(e:GetHandler())
		e01:SetType(EFFECT_TYPE_SINGLE)
		e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e01:SetValue(1)
		token:RegisterEffect(e01,true)			
	end
	Duel.SpecialSummonComplete()
end

function c170000201.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function c170000201.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
	end
end

function c170000201.ncondition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE then return end
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsCode(80019195) or ec:IsCode(511000152) or ec:IsCode(511000153) or ec:IsCode(511000154) or ec:IsCode(40640057)
end

function c170000201.noperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

function c170000201.spfilter(c,e,tp)
	return c:IsCode(40640057) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c170000201.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c170000201.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c170000201.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c170000201.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end