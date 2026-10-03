--フルール・ド・ヴェルティージュ
function c120000077.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000077,0))
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(c120000077.target)
	e1:SetOperation(c120000077.activate)
	c:RegisterEffect(e1)
end
function c120000077.filter(c,tp)
	return c:GetSummonPlayer()==tp
end
function c120000077.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return eg:IsExists(c120000077.filter,1,nil,1-tp) end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c120000077.filter,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c120000077.filter2(c,e,tp)
	return c:GetSummonPlayer()==tp and c:IsRelateToEffect(e)
end
function c120000077.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c120000077.filter2,nil,e,1-tp)
	local tc=g:GetFirst()
	if not tc then return end
	if g:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		tc=g:Select(tp,1,1,nil):GetFirst()
	end
	Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
end
