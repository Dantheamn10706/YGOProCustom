--幻影の騎士－ミラージュ・ナイト－
function c120000336.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c120000336.atkcon)
	e2:SetValue(c120000336.atkval)
	c:RegisterEffect(e2)
	--remove
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c120000336.rmcon)
	e3:SetOperation(c120000336.rmop)
	c:RegisterEffect(e3)
end
function c120000336.atkcon(e)
	return Duel.GetCurrentPhase()==PHASE_DAMAGE_CAL and e:GetHandler():GetBattleTarget()
end
function c120000336.atkval(e,c)
	return e:GetHandler():GetBattleTarget():GetAttack()
end
function c120000336.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBattledGroupCount()>0
end
function c120000336.spfilter1(c,e,tp)
	return c:IsCode(46986414) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000336.spfilter2(c,e,tp)
	return c:IsCode(45231177) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000336.rmop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)~=0 then
	if not Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetLocationCount(tp,LOCATION_MZONE)>=2
		and Duel.IsExistingMatchingCard(c120000336.spfilter1,tp,LOCATION_GRAVE,0,1,nil,e,tp)
		and Duel.IsExistingMatchingCard(c120000336.spfilter2,tp,LOCATION_GRAVE,0,1,nil,e,tp) then
			local g1=Duel.GetMatchingGroup(c120000336.spfilter1,tp,LOCATION_GRAVE,0,nil,e,tp)
			local g2=Duel.GetMatchingGroup(c120000336.spfilter2,tp,LOCATION_GRAVE,0,nil,e,tp)
			if g1:GetCount()>0 and g2:GetCount()>0 then 
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg1=g1:Select(tp,1,1,nil)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg2=g2:Select(tp,1,1,nil)
				sg1:Merge(sg2)
				Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP) end
		end	
	end
end
