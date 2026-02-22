--デス・ペナルティ
function c120000072.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000072,0))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_BATTLE_DESTROYED)
	e1:SetCondition(c120000072.condition)
	e1:SetTarget(c120000072.target)
	e1:SetOperation(c120000072.activate)
	c:RegisterEffect(e1)
end
function c120000072.cfilter(c,e,tp)
	return c:IsReason(REASON_BATTLE) and c:GetPreviousControler()==tp and c~=Duel.GetAttacker() 
end
function c120000072.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000072.cfilter,1,nil,e,tp)
end
function c120000072.desfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000072.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingMatchingCard(c120000072.desfilter,0,tp,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c120000072.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000072.desfilter,tp,0,LOCATION_ONFIELD,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=g:Select(tp,1,1,nil)
	Duel.HintSelection(dg)
	local atk=dg:GetFirst():GetAttack()/2
		Duel.BreakEffect()
		if Duel.Destroy(dg,REASON_EFFECT)>0 then
		if atk<0 then atk=0 end
			Duel.Damage(1-tp,atk,REASON_EFFECT)
	end	
end
