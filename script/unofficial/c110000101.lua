--オレイカルコス・トリトス
function c110000101.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c110000101.actcon)
	c:RegisterEffect(e1)
	--disable 1
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetDescription(aux.Stringid(110000101,0))
	e2:SetCode(EVENT_CHAIN_SOLVING)
	e2:SetRange(LOCATION_SZONE)
	e2:SetOperation(c110000101.disop)
	c:RegisterEffect(e2)
	--disable 2
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetDescription(aux.Stringid(110000101,0))
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c110000101.discon)
	e3:SetOperation(c110000101.disop2)
	c:RegisterEffect(e3)
	--selfdes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCondition(c110000101.sdcon2)
	e4:SetOperation(c110000101.sdop)
	c:RegisterEffect(e4)
	--add code
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_ADD_CODE)
	e5:SetRange(LOCATION_SZONE)
	e5:SetValue(48179391)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_ADD_CODE)
	e6:SetRange(LOCATION_SZONE)
	e6:SetValue(110000100)
	c:RegisterEffect(e6)
end
function c110000101.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110000101)==0
end
function c110000101.sdop(e,tp,eg,ep,ev,re,r,rp)	
	e:GetHandler():CopyEffect(511000256,RESET_EVENT+0x1fe0000)
	e:GetHandler():CopyEffect(110000100,RESET_EVENT+0x1fe0000)
	e:GetHandler():RegisterFlagEffect(110000101,RESET_EVENT+0x1fe0000,0,1)
end
function c110000101.actcon(e)
	local tc=Duel.GetFieldCard(e:GetHandler():GetControler(),LOCATION_SZONE,5)	
	return tc~=nil and tc:IsFaceup() and tc:GetCode()==110000100
end
function c110000101.sdcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(110000101)==0
end
function c110000101.disop(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) then return end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()==0 then return end
	local gc=g:GetFirst()
	if not gc:IsControler(tp) or not gc:IsType(TYPE_MONSTER) then return false end
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
	end		
end
function c110000101.cfilter(c,tp)
	return c:IsOnField() and c:IsControler(tp)
end
function c110000101.discon(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsActiveType(TYPE_SPELL+TYPE_TRAP) or not Duel.IsChainNegatable(ev) then return false end
	local ex,tg,tc=Duel.GetOperationInfo(ev,CATEGORY_DESTROY,CATEGORY_RELEASE,CATEGORY_REMOVE,CATEGORY_TODECK,CATEGORY_TOGRAVE,CATEGORY_TOHAND,
	CATEGORY_POSITION,CATEGORY_CONTROL,CATEGORY_DISABLE,CATEGORY_EQUIP,CATEGORY_ATKCHANGE,CATEGORY_DEFCHANGE,CATEGORY_LVCHANGE,CATEGORY_NEGATE)
	return ex and tg~=nil and tc+tg:FilterCount(c110000101.cfilter,nil,tp)-tg:GetCount()>0
end
function c110000101.disop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=re:GetHandler()
	if not tc:IsDisabled() then
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) and re:GetHandler():IsDestructable() then
			Duel.Destroy(re:GetHandler(),REASON_EFFECT)
		end
	end
end	