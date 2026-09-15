--タイム・ストリーム
function c120000266.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c120000266.cost)
	e1:SetTarget(c120000266.target)
	e1:SetOperation(c120000266.operation)
	c:RegisterEffect(e1)
end
function c120000266.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c120000266.filter1(c,e,tp)
	return c:IsFaceup() and c:IsAbleToExtra() and (c:IsCode(100000023) or c:IsCode(100000027) or c:IsCode(100000028) or c:IsCode(100000029) or c:IsCode(100000622))
end
function c120000266.filter2(c,e,tp)
	return c:IsFaceup() and c:IsAbleToExtra() and (c:IsCode(100000026) or c:IsCode(100000620) or c:IsCode(100000621))
end
function c120000266.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c120000266.filter1,tp,LOCATION_ONFIELD,0,1,nil,e,tp) or  
	Duel.IsExistingTarget(c120000266.filter2,tp,LOCATION_ONFIELD,0,1,nil,e,tp) end
	local g1=Duel.GetMatchingGroup(c120000266.filter1,tp,LOCATION_ONFIELD,0,nil)
	local g2=Duel.GetMatchingGroup(c120000266.filter2,tp,LOCATION_ONFIELD,0,nil)
	local op=0
	if g1:GetCount()>0 and g2:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(120000266,0),aux.Stringid(120000266,1))
	elseif g1:GetCount()>0 then
		op=Duel.SelectOption(tp,aux.Stringid(120000266,0))
	else op=Duel.SelectOption(tp,aux.Stringid(120000266,1))+1 end
	e:SetLabel(op)
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(120000266,0))
		local tg=Duel.SelectTarget(tp,c120000266.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
	else
		Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(120000266,1))
		local tg=Duel.SelectTarget(tp,c120000266.filter2,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,tg,1,0,0)
	end
end
function c120000266.matfilter1(c,e,tp,fusc,mat)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:GetReasonCard()==fusc 
end
function c120000266.spfilter1(c,e,tp)
	return c:IsCode(100000026) or c:IsCode(100000620) or c:IsCode(100000621)
end
function c120000266.spfilter2(c,e,tp)
	return c:IsCode(100000023) or c:IsCode(100000027) or c:IsCode(100000028) or c:IsCode(100000029) or c:IsCode(100000622)
end
function c120000266.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	if e:GetLabel()==0 then
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
			local mat=tc:GetMaterial()
			if tc and mat:IsExists(c120000266.matfilter1,1,nil,e,tp,tc,mat) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c120000266.spfilter1,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if not sg then return false end
			Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		end
	else
		local tc=Duel.GetFirstTarget()
		if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
			local mat=tc:GetMaterial()
			if tc and mat:IsExists(c120000266.matfilter1,1,nil,e,tp,tc,mat) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=Duel.SelectMatchingCard(tp,c120000266.spfilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp):GetFirst()
			if not sg then return false end
			Duel.SpecialSummon(sg,SUMMON_TYPE_FUSION,tp,tp,true,false,POS_FACEUP)
		end
	end
end