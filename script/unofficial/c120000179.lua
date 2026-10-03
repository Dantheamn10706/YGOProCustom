--ダーク・アーキタイプ
function c120000179.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000179,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCondition(c120000179.condition)
	e1:SetTarget(c120000179.target)
	e1:SetOperation(c120000179.activate)
	c:RegisterEffect(e1)
end
function c120000179.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and e:GetHandler():IsReason(REASON_BATTLE)
end
function c120000179.spfilter(c,e,tp,ft,rg,dam)
	local lv=c:GetLevel()
	return lv>0 and c:GetAttack()==dam and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and rg:CheckWithSumEqual(Card.GetLevel,lv,ft,99)
end
function c120000179.tgfilter(c)
	return c:GetLevel()>0 and c:IsAbleToGrave()
end
function c120000179.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local dam=Duel.GetBattleDamage(tp)
	if chkc then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then ft=-ft+1 else ft=1 end
	if chk==0 then
		local rg=Duel.GetMatchingGroup(c120000179.tgfilter,tp,LOCATION_HAND,0,nil)
		return Duel.IsExistingTarget(c120000179.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,ft,rg,dam)
	end
	local rg=Duel.GetMatchingGroup(c120000179.tgfilter,tp,LOCATION_HAND,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c120000179.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,ft,rg,dam)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c120000179.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then ft=-ft+1 else ft=1 end
	if not tc:IsRelateToEffect(e) or not tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then return end
	local rg=Duel.GetMatchingGroup(c120000179.tgfilter,tp,LOCATION_HAND,0,nil)
	local lv=tc:GetLevel()
	if rg:CheckWithSumEqual(Card.GetLevel,lv,ft,99) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local rm=rg:SelectWithSumEqual(tp,Card.GetLevel,lv,ft,99)
		Duel.SendtoGrave(rm,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
