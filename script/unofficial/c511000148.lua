--Five Star Twilight
function c511000148.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(511000148,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCondition(c511000148.condition)	
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000148.cost)
	e1:SetTarget(c511000148.sptg)
	e1:SetOperation(c511000148.spop)
	c:RegisterEffect(e1)
end

function c511000148.confilter(c)
	return c:IsCode(40640057)
end
function c511000148.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),LOCATION_MZONE,0)==1
		and Duel.IsExistingMatchingCard(c511000148.confilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,1,nil)
end

function c511000148.cfilter(c)
	return c:GetLevel()==5
end
function c511000148.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(1)
	if chk==0 then return Duel.CheckReleaseGroup(tp,c511000148.cfilter,1,nil) end
	local rg=Duel.SelectReleaseGroup(tp,c511000148.cfilter,1,1,nil)
	Duel.Release(rg,REASON_COST)
end

function c511000148.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,4,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,4,0,0)
end
function c511000148.spop(e,tp,eg,ep,ev,re,r,rp)
	local a={7021574,34419588,44632120,71036835}
	if not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) and Duel.GetLocationCount(tp,LOCATION_MZONE)>4
		then
		for i=1,4 do
			local token=Duel.CreateToken(tp,a[i])
			Duel.SpecialSummonStep(token,0,tp,tp,false,false,nil)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UNRELEASABLE_SUM)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			token:RegisterEffect(e1,true)
		end
		Duel.SpecialSummonComplete()
	end
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000148.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end

function c511000148.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(1-tp) and chkc:IsFaceup() and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_MZONE,1,1,nil)
end

function c511000148.operation(e,tp,eg,ep,ev,re,r,rp)
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

function c511000148.ncondition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==tp and Duel.GetCurrentPhase()==PHASE_BATTLE then return end
	local ec=eg:GetFirst()
	return ec:IsFaceup() and ec:IsCode(71036835) or ec:IsCode(34419588) or ec:IsCode(446632120) or ec:IsCode(7021574) or ec:IsCode(40640057)
end

function c511000148.noperation(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateAttack()
end

function c511000148.spfilter(c,e,tp)
	return c:IsCode(40640057) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c511000148.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511000148.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function c511000148.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c511000148.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
end