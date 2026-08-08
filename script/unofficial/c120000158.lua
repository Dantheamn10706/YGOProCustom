--ドドドガッサー
function c120000158.initial_effect(c)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e1:SetOperation(c120000158.atkop)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000158,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FLIP)
	e2:SetTarget(c120000158.destg)
	e2:SetOperation(c120000158.desop)
	c:RegisterEffect(e2)
end
function c120000158.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local val=0
		if Duel.GetLP(tp)>Duel.GetLP(1-tp) then
			val=Duel.GetLP(tp)-Duel.GetLP(1-tp)
		else
			val=Duel.GetLP(1-tp)-Duel.GetLP(tp)
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
end
function c120000158.filter(c,e)
	return c:IsType(TYPE_MONSTER) and (not e or c:IsRelateToEffect(e)) and c:IsDestructable()
end
function c120000158.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and c120000158.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000158.filter,tp,0,LOCATION_ONFIELD,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c120000158.filter,tp,0,LOCATION_ONFIELD,2,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c120000158.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c120000158.filter,nil,e)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
