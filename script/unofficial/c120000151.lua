--重力崩壊
function c120000151.initial_effect(c)
	--Activate(summon)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SUMMON)
	e1:SetCondition(c120000151.condition)
	e1:SetCost(c120000151.cost)
	e1:SetTarget(c120000151.target)
	e1:SetOperation(c120000151.activate)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e3)
end
function c120000151.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0 and eg:IsExists(Card.IsControler,1,nil,1-tp)
end
function c120000151.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsType,1,nil,TYPE_SYNCHRO) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectReleaseGroup(tp,Card.IsType,1,1,nil,TYPE_SYNCHRO)
	Duel.Release(g,REASON_COST)
	local atk=g:GetFirst():GetAttack()
	e:SetLabel(atk)
end
function c120000151.filter(c,atk)
	return c:IsType(TYPE_MONSTER) and c:GetAttack()<atk
end
function c120000151.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=eg:Filter(c120000151.filter,nil,e:GetLabel(),1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c120000151.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c120000151.filter,nil,e:GetLabel(),1-tp)
	Duel.NegateSummon(g)
	Duel.Destroy(g,REASON_EFFECT)
end
