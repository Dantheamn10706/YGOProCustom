--機皇帝ワイゼル∞
function c450000306.initial_effect(c)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetCondition(c450000306.condition)
	e1:SetValue(c450000306.val)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e2)
	--cannot attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetTargetRange(LOCATION_MZONE,0)
	e3:SetCondition(c450000306.condition)
	e3:SetTarget(c450000306.antarget)
	c:RegisterEffect(e3)
	--cannot be target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_ONFIELD)
	e4:SetCondition(c450000306.condition)
	e4:SetValue(c450000306.tgfilter)
	c:RegisterEffect(e4)
	--equip
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(450000306,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(c450000306.eqtg)
	e5:SetOperation(c450000306.eqop)
	c:RegisterEffect(e5)
	--destroy
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(c450000306.condition)
	e6:SetTarget(c450000306.destg)
	e6:SetOperation(c450000306.desop)
	c:RegisterEffect(e6)	
end
function c450000306.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_MONSTER)
end
function c450000306.val(e,c)
	return Duel.GetLP(e:GetHandler():GetOwner())
end
function c450000306.antarget(e,c)
	return c~=e:GetHandler()
end
function c450000306.tgfilter(e,re)
	return re:GetHandler():GetControler()~=e:GetHandler():GetControler()
end
function c450000306.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_MONSTER) and c:IsAbleToChangeControler()
end
function c450000306.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c450000306.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c450000306.eqfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c450000306.eqfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c450000306.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsFaceup() and c:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		if tc and tc:IsType(TYPE_SYNCHRO) and not tc:IsType(TYPE_EFFECT) then 
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetValue(c450000306.eqlimit)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetRange(LOCATION_SZONE)
				e2:SetValue(TYPE_SYNCHRO+TYPE_MONSTER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			if atk>0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(atk)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
			end	
		elseif tc and tc:IsType(TYPE_SYNCHRO) and tc:IsType(TYPE_EFFECT) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetValue(c450000306.eqlimit)
				e1:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e1)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetCode(EFFECT_CHANGE_TYPE)
				e2:SetRange(LOCATION_SZONE)
				e2:SetValue(TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			if atk>0 then
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_EQUIP)
				e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
				e3:SetCode(EFFECT_UPDATE_ATTACK)
				e3:SetValue(atk)
				e3:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e3)
			end
		else Duel.SendtoGrave(tc,REASON_EFFECT) end
	end
end
function c450000306.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c450000306.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
function c450000306.desop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,0,nil,TYPE_MONSTER)
	Duel.Destroy(sg,REASON_EFFECT)
end
	