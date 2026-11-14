--ゴーゴンの眼
function c511002444.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_POSITION)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHANGE_POS)
	e1:SetTarget(c511002444.target)
	e1:SetOperation(c511002444.operation)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_MSET)
	e2:SetTarget(c511002444.target2)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetTarget(c511002444.target2)
	c:RegisterEffect(e3)
	--Position
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_CHANGE_POS)
	e4:SetRange(LOCATION_SZONE)
	e4:SetTarget(c511002444.target)
	e4:SetOperation(c511002444.operation)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EVENT_MSET)
	e5:SetTarget(c511002444.target2)
	c:RegisterEffect(e5)
	local e6=e4:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c511002444.target2)
	c:RegisterEffect(e6)
	--disable
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_SZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetCode(EFFECT_DISABLE)
	e7:SetTarget(c511002444.distg)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	c:RegisterEffect(e8)
	--Damage
	local e9=Effect.CreateEffect(c)
	e9:SetCategory(CATEGORY_DAMAGE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_SZONE)
	e9:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e9:SetCode(EVENT_DESTROYED)
	e9:SetTarget(c511002444.damtg)
	e9:SetOperation(c511002444.damop)
	c:RegisterEffect(e9)
end
function c511002444.filter1(c,tp)
	return c:IsFacedown() and c:IsPreviousPosition(POS_FACEUP) and c:IsControler(1-tp)
end
function c511002444.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511002444.filter1,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c511002444.filter2(c,tp)
	return c:IsFacedown() and c:IsControler(1-tp)
end
function c511002444.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511002444.filter2,1,nil,tp) end
	Duel.SetTargetCard(eg)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,eg,eg:GetCount(),0,0)
end
function c511002444.filter3(c,e)
	return c:IsFacedown() or c:IsDefensePos() and c:IsRelateToEffect(e)
end
function c511002444.operation(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=eg:Filter(c511002444.filter3,nil,e,tp)
	if Duel.ChangePosition(g,0x4,0x4,0x4,0x4,true) then
		local og=Duel.GetOperatedGroup()
		local oc=og:GetFirst()
		while oc do
	local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			oc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_DISABLE)
			oc:RegisterEffect(e2)
			oc=og:GetNext()
		end
	end
end
function c511002444.distg(e,c)
	return c:IsFaceup() and c:IsDefensePos()
end
function c511002444.cfilter(c,tp)
	return ep~=tp and c:IsPreviousPosition(POS_FACEUP_DEFENSE) and c:IsControler(1-tp)
end
function c511002444.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(c511002444.cfilter,1,nil,tp) end
	local g=eg:Filter(c511002444.cfilter,nil,tp)
	Duel.SetTargetCard(g)
	tc=g:GetFirst()
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(tc:GetDefense()/2)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,tc:GetDefense()/2)
end
function c511002444.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end