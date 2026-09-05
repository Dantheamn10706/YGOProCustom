--剣の采配
function c120000325.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_HANDES+CATEGORY_DESTROY)
	e1:SetCode(EVENT_DRAW)
	e1:SetCondition(c120000325.condition)
	e1:SetOperation(c120000325.activate)
	c:RegisterEffect(e1)
end
function c120000325.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_WARRIOR)
end
function c120000325.condition(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and r==REASON_RULE and Duel.IsExistingMatchingCard(c120000325.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end
function c120000325.dfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c120000325.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	if tc:IsLocation(LOCATION_HAND) then
		Duel.ConfirmCards(tp,tc)
		if tc:IsType(TYPE_SPELL+TYPE_TRAP) then
			local g=Duel.GetMatchingGroup(c120000325.dfilter,tp,0,LOCATION_ONFIELD,nil)
			local opt=0
			if g:GetCount()==0 then
				opt=Duel.SelectOption(tp,aux.Stringid(120000325,0))
			else
				opt=Duel.SelectOption(tp,aux.Stringid(120000325,0),aux.Stringid(120000325,1))
			end
			if opt==0 then Duel.Destroy(tc,REASON_EFFECT)
			else
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
				local dg=g:Select(tp,1,1,nil)
				Duel.Destroy(dg,REASON_EFFECT)
				Duel.ShuffleHand(1-tp)
			end
		end
	else
		Duel.ShuffleHand(1-tp)
	end
end
