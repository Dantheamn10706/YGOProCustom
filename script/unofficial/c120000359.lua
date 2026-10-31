--ヘイト・クレバス
function c120000359.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c120000359.condition)
	e1:SetTarget(c120000359.target)
	e1:SetOperation(c120000359.activate)
	c:RegisterEffect(e1)
end
function c120000359.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsReason(REASON_DESTROY) and c:IsType(TYPE_MONSTER)  
end
function c120000359.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000359.cfilter,1,nil,tp)
end
function c120000359.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000359.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000359.filter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,0)
end
function c120000359.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.SelectMatchingCard(tp,c120000359.filter,tp,0,LOCATION_ONFIELD,1,1,nil)
	local tc=g:GetFirst()
	local atk=tc:GetBaseAttack()
	if tc then
	Duel.Destroy(tc,REASON_EFFECT)
	if atk<0 then atk=0 end
	Duel.Damage(tc:GetControler(),atk,REASON_EFFECT)
	end
end	