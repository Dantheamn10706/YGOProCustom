--ZS－幻影賢者
function c120000017.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000017,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_REMOVE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCondition(c120000017.spcon)
	e1:SetCost(c120000017.spcost)
	e1:SetTarget(c120000017.sptg)
	e1:SetOperation(c120000017.spop)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000017,1))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCountLimit(1)
	e2:SetCondition(c120000017.condition)
	e2:SetTarget(c120000017.target)
	e2:SetOperation(c120000017.operation)
	c:RegisterEffect(e2)
end
function c120000017.filter(c,tp)
	return not c:IsType(TYPE_TOKEN) and c:IsType(TYPE_MONSTER) and c:IsControler(tp)
end
function c120000017.spcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c120000017.filter,nil,tp)
	local tc=g:GetFirst()
	return e:GetHandler():IsType(TYPE_MONSTER) and g:GetCount()==1 and tc
end
function c120000017.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c120000017.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=eg:GetFirst()
	if chk==0 then return e:GetHandler():IsDestructable()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and tc and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,tc,1,0,0)
end
function c120000017.rmfilter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:GetAttack()<atk
end
function c120000017.spop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	Duel.Hint(HINT_CARD,0,120000017)
	if tc and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.BreakEffect()
		local dg=Duel.GetMatchingGroup(c120000017.rmfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,tc,tc:GetAttack())
		Duel.Remove(dg,POS_FACEUP,REASON_EFFECT)
	end		
end
function c120000017.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsSetCard(0x7f)
end
function c120000017.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c120000017.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c120000017.operation(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end