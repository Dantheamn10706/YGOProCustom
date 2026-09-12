--死のマジック・ボックス
function c78800017.initial_effect(c)
	--Activate1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_CONTROL+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c78800017.spcon)
	e1:SetTarget(c78800017.sptg)
	e1:SetOperation(c78800017.spop)
	c:RegisterEffect(e1)
	--Activate2
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(c78800017.sptg1)
	e2:SetOperation(c78800017.spop1)
	c:RegisterEffect(e2)
end
function c78800017.spfilter(c)
	return c:GetOwner()~=c:GetControler() and c:IsFaceup() and c:IsCode(46986414) 
end
function c78800017.spcon(e,c)
	if c==nil then return true end
	return Duel.IsExistingMatchingCard(c78800017.spfilter,e:GetHandlerPlayer(),0,LOCATION_ONFIELD,1,nil)
end
function c78800017.filter(c,e,tp)
	return c:GetOwner()~=c:GetControler() and c:IsFaceup() and c:IsCode(46986414) 
end
function c78800017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c78800017.filter(chkc,e,tp) end
	if chk==0 then return Duel.IsExistingTarget(c78800017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c78800017.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil,e,tp)
end
function c78800017.filter2(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c78800017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local tc=Duel.GetFirstTarget()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c78800017.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	local dc=dg:GetFirst()
	if dc and tc and tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP_ATTACK,true) then
		tc:ResetEffect(EFFECT_SET_CONTROL,RESET_CODE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_CONTROL)
		e1:SetValue(tc:GetOwner())
		e1:SetReset(RESET_EVENT+0xec0000)
		tc:RegisterEffect(e1)
		Duel.Destroy(dc,REASON_EFFECT)	
	end
end
function c78800017.filter1(c,e,tp)
	return c:GetOwner()==c:GetControler() and c:IsFaceup() and c:IsCode(46986414) 
end
function c78800017.sptg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(c78800017.filter1,tp,LOCATION_ONFIELD,0,1,nil,e,tp)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c78800017.filter1,tp,LOCATION_ONFIELD,0,1,1,nil,e,tp)
end
function c78800017.spop1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,c78800017.filter2,tp,0,LOCATION_ONFIELD,1,1,nil)
	local dc=dg:GetFirst()
	if dc then
		Duel.Destroy(dc,REASON_EFFECT)	
	end
end
