--激流蘇生
function c120000358.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCondition(c120000358.condition)
	e1:SetTarget(c120000358.target)
	e1:SetOperation(c120000358.operation)
	c:RegisterEffect(e1)
end
function c120000358.cfilter(c,tp)
	return c:GetPreviousControler()==tp and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) 
end
function c120000358.condition(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c120000358.cfilter,1,nil,tp)
end
function c120000358.spfilter(c,e,tp)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_WATER) 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c120000358.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ct=eg:FilterCount(c120000358.spfilter,nil,e,tp)
		return ct>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
	end
	Duel.SetTargetCard(eg)
	local g=eg:Filter(c120000358.spfilter,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function c120000358.operation(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=eg:Filter(c120000358.spfilter,nil,e,tp)
	if ft<sg:GetCount() then return end
	local ct=Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	Duel.Damage(1-tp,ct*500,REASON_EFFECT)
end