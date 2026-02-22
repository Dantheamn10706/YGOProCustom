--バサラ
function c120000123.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e2:SetDescription(aux.Stringid(120000123,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1)
	e2:SetCost(c120000123.descost)
	e2:SetTarget(c120000123.destg)
	e2:SetOperation(c120000123.desop)
	c:RegisterEffect(e2)
end
function c120000123.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER)
		and Duel.IsExistingTarget(c120000123.dfilter,tp,0,LOCATION_ONFIELD,1,nil,c:GetLevel())
end
function c120000123.dfilter(c,lv)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup() and c:IsLevelAbove(lv+1) and c:IsDestructable()
end
function c120000123.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000123.cfilter,tp,LOCATION_ONFIELD,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c120000123.cfilter,tp,LOCATION_ONFIELD,0,1,1,nil,tp)
	local lv=g:GetFirst():GetLevel()
	e:SetLabel(lv)
	Duel.Release(g,REASON_COST)
end
function c120000123.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000123.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e:GetLabel()) end
	local g=Duel.GetMatchingGroup(c120000123.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,800)
end
function c120000123.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,c120000123.dfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e:GetLabel())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
