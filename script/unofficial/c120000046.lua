--RR－ラスト・ストリクス
function c120000046.initial_effect(c)
	--recover
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000046,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000046.reccon)
	e1:SetTarget(c120000046.rectg)
	e1:SetOperation(c120000046.recop)
	c:RegisterEffect(e1)
end
function c120000046.reccon(e,tp,eg,ev,ep,re,r,rp)
	return Duel.GetBattleDamage(tp)>0
end
function c120000046.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
      local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and not e:GetHandler():IsStatus(STATUS_CHAINING) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000046.recop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
    local ct=Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
    e1:SetLabel(ct)
	e1:SetOperation(c120000046.damop)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c120000046.damop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
    local ct=e:GetLabel()
	if Duel.GetBattleDamage(tp)-(ct*100)>0 then Duel.ChangeBattleDamage(tp,Duel.GetBattleDamage(tp)-(ct*100))
	else Duel.ChangeBattleDamage(tp,0) end
      Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end