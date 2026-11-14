--モンスター・スロット
function c120000271.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000271.condition)
	e1:SetTarget(c120000271.target)
	e1:SetOperation(c120000271.activate)
	c:RegisterEffect(e1)
end
function c120000271.filter(c)
	return c:IsType(TYPE_MONSTER) and c:GetLevel()>0
end
function c120000271.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c120000271.filter,tp,LOCATION_ONFIELD,0,nil)>0 
		and Duel.GetMatchingGroupCount(c120000271.filter,tp,LOCATION_GRAVE,0,nil)>0
end
function c120000271.filter1(c,tp)
	local lv=c:GetLevel()
	return lv>0 and c:IsType(TYPE_MONSTER) and c:IsFaceup() and Duel.IsExistingTarget(c120000271.filter2,tp,LOCATION_GRAVE,0,1,nil,lv)
end
function c120000271.filter2(c,lv)
	return c:GetLevel()==lv and c:IsAbleToRemove() 
end
function c120000271.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanSpecialSummon(tp) 
		and Duel.IsExistingTarget(c120000271.filter1,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g1=Duel.SelectTarget(tp,c120000271.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g2=Duel.SelectTarget(tp,c120000271.filter2,tp,LOCATION_GRAVE,0,1,1,nil,g1:GetFirst():GetLevel())
	e:SetLabelObject(g1:GetFirst())
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g2,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_HAND)
end
function c120000271.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc1=e:GetLabelObject()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc2=g:GetFirst()
	if tc2==tc1 then tc2=g:GetNext() end
	if tc1:IsFacedown() or not tc1:IsRelateToEffect(e) then return end
	if not tc2:IsRelateToEffect(e) or tc2:GetLevel()~=tc1:GetLevel() or Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)==0 then return end
	Duel.BreakEffect()
	if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	local dr=Duel.GetOperatedGroup():GetFirst()
	Duel.ConfirmCards(1-tp,dr)
	Duel.BreakEffect()
	if dr:GetLevel()==tc1:GetLevel() then
		if Duel.SpecialSummon(dr,0,tp,tp,false,false,POS_FACEUP)==0 then
			Duel.ShuffleHand(tp)
		end
	else 
		Duel.Remove(tc1,POS_FACEUP,REASON_EFFECT)
		Duel.Remove(dr,POS_FACEUP,REASON_EFFECT)
		Duel.ShuffleHand(tp)
	end
end