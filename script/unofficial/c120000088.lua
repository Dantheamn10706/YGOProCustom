--ストイック・チャレンジ
function c120000088.initial_effect(c)
	aux.AddEquipProcedure(c,nil,c120000088.eqfilter)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000088,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c120000088.condition)
	e1:SetTarget(c120000088.target)
	e1:SetOperation(c120000088.activate)
	c:RegisterEffect(e1)
	--Damage Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(0,1)
	e2:SetValue(c120000088.damval)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_EQUIP)
	e3:SetCode(EFFECT_CANNOT_TRIGGER)
	c:RegisterEffect(e3)
	--Destroy 2nd End Phase
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(120000088,1))
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCountLimit(1)
	e4:SetOperation(c120000088.detop)
	c:RegisterEffect(e4)
end
function c120000088.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c120000088.filter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ) and c:GetOverlayCount()>0
end
function c120000088.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c120000088.filter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c120000088.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c120000088.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c120000088.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c120000088.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
end
function c120000088.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=tc:GetOverlayCount()
		tc:RemoveOverlayCard(tp,ct,ct,REASON_EFFECT)
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetValue(c120000088.eqlimit)
		e1:SetLabelObject(tc)
		c:RegisterEffect(e1)
		--Atk
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_SZONE)
		e2:SetValue(ct*600)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		--Disable
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetCode(EFFECT_DISABLE)
		e3:SetRange(LOCATION_SZONE)
		c:RegisterEffect(e3)
	end
end
function c120000088.eqlimit(e,c)
	return e:GetLabelObject()==c
end
function c120000088.damval(e,re,dam,r,rp,rc)
	if bit.band(r,REASON_BATTLE)~=0 and rc==e:GetHandler():GetEquipTarget() and rc:GetBattleTarget()~=nil then
		return dam*2
	else return dam end
end
function c120000088.detop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()==1-tp then return end
	local c=e:GetHandler()
	local tc=c:GetEquipTarget()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==2 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_PHASE+PHASE_END)
		e1:SetCountLimit(1)
		e1:SetRange(LOCATION_SZONE)
		e1:SetLabelObject(tc)
		e1:SetOperation(c120000088.desop)
		e1:SetReset(RESET_PHASE+PHASE_END+RESET_SELF_TURN,1)
		Duel.RegisterEffect(e1,tp)
	end
end
function c120000088.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.Hint(HINT_CARD,0,120000088)
		Duel.Destroy(tc,REASON_EFFECT)
end
