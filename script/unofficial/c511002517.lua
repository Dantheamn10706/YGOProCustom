--機皇神マシニクル∞³
function c511002517.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(63468625,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetCountLimit(1)
	e1:SetTarget(c511002517.eqtg)
	e1:SetOperation(c511002517.eqop)
	c:RegisterEffect(e1)
	--damage
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(63468625,1))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_ONFIELD)
	e2:SetCondition(c511002517.damcon)
	e2:SetCost(c511002517.damcost)
	e2:SetTarget(c511002517.damtg)
	e2:SetOperation(c511002517.damop)
	c:RegisterEffect(e2)
	--gain eff
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10032958,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_ONFIELD)
	e3:SetCost(c511002517.effcost)
	e3:SetTarget(c511002517.efftg)
	e3:SetOperation(c511002517.effop)
	c:RegisterEffect(e3)
	--Destroy replace
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(c511002517.desreptg)
	c:RegisterEffect(e4)
end
function c511002517.eqfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_SYNCHRO) and c:IsAbleToChangeControler()
end
function c511002517.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(1-tp) and c511002517.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsType(TYPE_MONSTER)
		and Duel.IsExistingTarget(c511002517.eqfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	local g=Duel.SelectTarget(tp,c511002517.eqfilter,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,1,0,0)
end
function c511002517.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) and tc:IsType(TYPE_MONSTER) then
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local atk=tc:GetTextAttack()
			if atk<0 then atk=0 end
			if not Duel.Equip(tp,tc,c,false) then return end
				--Add Equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_COPY_INHERIT+EFFECT_FLAG_OWNER_RELATE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetValue(c511002517.eqlimit)
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
				e1:SetValue(c511002517.eqlimit)
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
function c511002517.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c511002517.damcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c511002517.dcfilter(c)
	return c:GetFlagEffect(63468625)~=0 or c:IsType(TYPE_SYNCHRO) and c:IsAbleToGraveAsCost()
end
function c511002517.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetEquipGroup():IsExists(c511002517.dcfilter,1,nil) and e:GetHandler():IsType(TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=e:GetHandler():GetEquipGroup():FilterSelect(tp,c511002517.dcfilter,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	local atk=g:GetFirst():GetTextAttack()
	if atk<0 then atk=0 end
	e:SetLabel(atk)
end
function c511002517.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(e:GetLabel())
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,e:GetLabel())
end
function c511002517.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function c511002517.cfilter(c)
	return c:IsSetCard(0x557) or c:IsSetCard(0x507) or c:IsSetCard(0x525) or c:IsSetCard(0x50d) and not c:IsSetCard(0x13) and c:IsAbleToGraveAsCost()
end
function c511002517.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c511002517.cfilter,tp,LOCATION_HAND,0,1,nil) and e:GetHandler():IsType(TYPE_MONSTER) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c511002517.cfilter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetLabelObject(g:GetFirst())
end
function c511002517.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local tc=e:GetLabelObject()
	Duel.SetTargetCard(tc)
end
function c511002517.effop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc then
		c:CopyEffect(tc:GetOriginalCode(),RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,1)
	end
end
function c511002517.repfilter(c)
	return c:IsSetCard(0x557) or c:IsSetCard(0x507) or c:IsSetCard(0x525) or c:IsSetCard(0x50d) and not c:IsSetCard(0x13) and c:IsAbleToRemove()
end
function c511002517.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) 
		and Duel.IsExistingMatchingCard(c511002517.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectYesNo(tp,aux.Stringid(100000068,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c511002517.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end