--マジカルシルクハット
local c504700140,id=GetID()
if not c504700140.gl_chk then
	c504700140.gl_chk=true
	local regeff=Card.RegisterEffect
	Card.RegisterEffect=function(c,e,f)
		local tc=e:GetOwner()
		if tc then
			local tg=e:GetTarget()
			if tg then
				if c35803249 and tg==c35803249.distg then --Jinzo - Lord
					--Debug.Message('"Jinzo - Lord" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				elseif c51452091 and tg==c51452091.distarget then --Royal Decree
					--Debug.Message('"Royal Decree" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				elseif c77585513 and tg==c77585513.distg then --Jinzo
					--Debug.Message('"Jinzo" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				elseif c84636823 and tg==c84636823.distg then --Spell Canceller
					--Debug.Message('"Spell Canceller" detected')
					e:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
				end
			end
		end
		return regeff(c,e,f)
	end
end
function c504700140.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c504700140.condition)
	e1:SetTarget(c504700140.target)
	e1:SetOperation(c504700140.activate)
	c:RegisterEffect(e1)
	--remain field
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e2)
end
function c504700140.cfilter(c)
	return c:IsFaceup()
end
function c504700140.condition(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<3 or Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return false end
	return Duel.IsExistingMatchingCard(c504700140.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c504700140.tgfilter(c)
	return c:IsType(TYPE_MONSTER)
end
function c504700140.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_ONFIELD) and chkc:IsControler(tp) and c504700140.tgfilter(chkc,tp) end
	if chk==0 then return not Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT)
	and Duel.GetLocationCount(tp,LOCATION_MZONE)>2 and Duel.IsExistingMatchingCard(c504700140.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
	and Duel.IsExistingMatchingCard(c504700140.tgfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,3,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,3,0,0)
end
function c504700140.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if Duel.IsPlayerAffectedByEffect(tp,CARD_BLUEEYES_SPIRIT) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c504700140.tgfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		c:RegisterFlagEffect(504700140,RESET_EVENT+RESETS_STANDARD_DISABLE,0,0,fid)
		--if tc and tc:IsFaceup() and tc:IsHasEffect(EFFECT_DEVINE_LIGHT) then Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
		--else Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE) end
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(TYPE_TOKEN)
			e1:SetLabel(fid)
			e1:SetCondition(c504700140.econ)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1,true)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_REMOVE_RACE)
			e2:SetValue(RACE_ALL)
			tc:RegisterEffect(e2,true)
			local e3=e1:Clone()
			e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
			e3:SetValue(0xff)
			tc:RegisterEffect(e3,true)
			local e4=e1:Clone()
			e4:SetCode(EFFECT_SET_BASE_ATTACK)
			e4:SetValue(0)
			tc:RegisterEffect(e4,true)
			local e5=e1:Clone()
			e5:SetCode(EFFECT_SET_BASE_DEFENSE)
			e5:SetValue(0)
			tc:RegisterEffect(e5,true)
			local e6=e1:Clone()
			e6:SetCode(EFFECT_CHANGE_LEVEL)
			e6:SetValue(0)
			tc:RegisterEffect(e6,true)
			local e7=Effect.CreateEffect(c)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e7:SetCode(EFFECT_UNRELEASABLE_SUM)
			e7:SetValue(1)
			e7:SetLabel(fid)
			e7:SetCondition(c504700140.econ)
			e7:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e7,true)
			local e8=e7:Clone()
			e8:SetCode(EFFECT_UNRELEASABLE_NONSUM)
			tc:RegisterEffect(e8,true)
			tc:RegisterFlagEffect(504700140+1,RESET_EVENT+RESETS_STANDARD_DISABLE,0,0,fid)
	end
		for i=1,3 do
			local hat=Duel.CreateToken(tp,511005062)
			Duel.MoveToField(hat,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_TOKEN)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				hat:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_RACE)
				e2:SetValue(RACE_ALL)
				hat:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
				e3:SetValue(0xff)
				hat:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(0)
				hat:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(0)
				hat:RegisterEffect(e5,true)
				local e6=Effect.CreateEffect(tc)
				e6:SetType(EFFECT_TYPE_SINGLE)
				e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
				--e6:SetValue(c504700140.indval)
				hat:RegisterEffect(e6,true)
				local e7=e1:Clone()
				e7:SetType(EFFECT_TYPE_SINGLE)
				e7:SetCode(EFFECT_CANNOT_ATTACK)
				hat:RegisterEffect(e7,true)
				local e8=e1:Clone()
				e8:SetType(EFFECT_TYPE_SINGLE)
				e8:SetCode(EFFECT_UNRELEASABLE_SUM)
				e8:SetValue(1)
				hat:RegisterEffect(e8,true)
				local e9=e8:Clone()
				e9:SetType(EFFECT_TYPE_SINGLE)
				e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
				e9:SetValue(1)
				hat:RegisterEffect(e9,true)
				local e10=e1:Clone()
				e10:SetType(EFFECT_TYPE_SINGLE)
				e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
				e10:SetValue(1)
				hat:RegisterEffect(e10,true)
				local e11=e1:Clone()
				e11:SetType(EFFECT_TYPE_SINGLE)
				e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
				e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
				e11:SetValue(1)
				hat:RegisterEffect(e11,true)
				--Destroy token
				local e12=Effect.CreateEffect(c)
				e12:SetCategory(CATEGORY_DESTROY)
				e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
				e12:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e12:SetCode(EVENT_FLIP)
				e12:SetOperation(c504700140.hatop)
				e12:SetReset(RESET_EVENT+RESETS_STANDARD)
				hat:RegisterEffect(e12)
				hat:SetStatus(STATUS_NO_LEVEL,true)
				hat:RegisterFlagEffect(504700140+2,RESET_EVENT+0x17a0000,0,0,fid)
			end
		local gs1=Duel.GetMatchingGroup(c504700140.gsfilter,tp,LOCATION_ONFIELD,0,nil)
		Duel.ChangePosition(gs1,POS_FACEDOWN_DEFENSE)
		Duel.ShuffleSetCard(gs1)
		--destroy
		local e13=Effect.CreateEffect(c)
		e13:SetCategory(CATEGORY_DESTROY)
		e13:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e13:SetRange(LOCATION_SZONE)
		e13:SetCode(EVENT_BATTLE_START)
		e13:SetLabelObject(tc)
		e13:SetLabel(fid)
		e13:SetCondition(c504700140.descon1)
		e13:SetOperation(c504700140.desop2)
		e13:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e13)
		local e14=Effect.CreateEffect(c)
		e14:SetCategory(CATEGORY_DESTROY)
		e14:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e14:SetRange(LOCATION_SZONE)
		e14:SetCode(EVENT_LEAVE_FIELD)
		e14:SetLabelObject(tc)
		e14:SetLabel(fid)
		e14:SetCondition(c504700140.descon2)
		e14:SetOperation(c504700140.desop2)
		e14:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e14)
		--
		local e15=Effect.CreateEffect(c)
		e15:SetCategory(CATEGORY_DESTROY)
		e15:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e15:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e15:SetRange(LOCATION_SZONE)
		e15:SetCode(EVENT_CHAINING)
		e15:SetLabelObject(tc)
		e15:SetLabel(fid)
		e15:SetCondition(c504700140.descon3)
		e15:SetOperation(c504700140.desop2)
		e15:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e15)
		--
		local e16=Effect.CreateEffect(c)
		e16:SetCategory(CATEGORY_DESTROY)
		e16:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e16:SetRange(LOCATION_SZONE)
		e16:SetCode(EVENT_FLIP_SUMMON)
		e16:SetLabelObject(tc)
		e16:SetLabel(fid)
		e16:SetCondition(c504700140.descon2)
		e16:SetOperation(c504700140.desop3)
		e16:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e16)
		--Reset
		local e17=Effect.CreateEffect(c)
		e17:SetCategory(CATEGORY_DESTROY)
		e17:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
		e17:SetCode(EVENT_LEAVE_FIELD)
		e17:SetLabelObject(tc)
		e17:SetLabel(fid)
		e17:SetOperation(c504700140.retop1)
		c:RegisterEffect(e17)
		--
		local e18=Effect.CreateEffect(c)
		e18:SetCategory(CATEGORY_DESTROY)
		e18:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e18:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_REPEAT+EFFECT_FLAG_NO_TURN_RESET)
		e18:SetRange(LOCATION_SZONE)
		e18:SetCode(EVENT_ADJUST)
		e18:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
		e18:SetLabelObject(tc)
		e18:SetLabel(fid)
		e18:SetCondition(c504700140.retcon2)
		e18:SetOperation(c504700140.retop2)
		e18:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e18)
		--Set Spell or Trap Cards
		local e19=Effect.CreateEffect(c)
		e19:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e19:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e19:SetType(EFFECT_TYPE_IGNITION)
		e19:SetRange(LOCATION_SZONE)
		e19:SetCost(c504700140.stcost)
		e19:SetTarget(c504700140.sttar)
		e19:SetOperation(c504700140.stop)
		e19:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e19)
end
function c504700140.tdfilter(c,fid)
	return c:IsFaceup() and c:GetFlagEffectLabel(504700140)==fid and not (c:IsStatus(STATUS_DISABLED) or c:IsDisabled()) 
end
function c504700140.econ(e,tp)
	local fid=e:GetLabel()
	local ct=Duel.GetMatchingGroupCount(c504700140.tdfilter,Duel.GetTurnPlayer(),LOCATION_ONFIELD,0,nil,fid)
	return ct>0
end
function c504700140.hatop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function c504700140.desfilter(c,fid)
	return c:GetFlagEffectLabel(504700140+2)==fid or c:GetFlagEffectLabel(504700140+3)==fid
end
function c504700140.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if not tc or tc:IsFaceup() and (e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled()) then return false end
	local g=Duel.GetMatchingGroup(c504700140.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	Duel.Destroy(g,REASON_EFFECT)
	if tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK) 
	elseif tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end	
	e:GetHandler():ResetFlagEffect(504700140)
	tc:ResetFlagEffect(504700140+1)
end
function c504700140.descon1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() then return false end
	local tc=e:GetLabelObject()
	return tc and tc==Duel.GetAttackTarget() and tc:GetFlagEffectLabel(504700140+1)==e:GetLabel()
end
function c504700140.descon2(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() then return false end
	local tc=e:GetLabelObject()
	return tc and tc:GetFlagEffectLabel(504700140+1)==e:GetLabel() and eg:IsContains(tc) 
end
function c504700140.descon3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsStatus(STATUS_BATTLE_DESTROYED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	if not tg or not tg:IsContains(tc) then return false end
	return loc~=LOCATION_DECK
end
function c504700140.desop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() then return false end
	local g=Duel.GetMatchingGroup(c504700140.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	Duel.Destroy(g,REASON_EFFECT)
	if tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK) 
	elseif tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end	
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	tc:ResetFlagEffect(504700140+1)
end
function c504700140.desop3(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() then return false end
	local g=Duel.GetMatchingGroup(c504700140.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	Duel.Destroy(g,REASON_EFFECT)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	tc:ResetFlagEffect(504700140+1)
end
function c504700140.retop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	if tc:IsStatus(STATUS_FLIP_SUMMON_TURN) or e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() then return false end
	local g=Duel.GetMatchingGroup(c504700140.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	Duel.Destroy(g,REASON_EFFECT)
	if tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK) 
	elseif tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end	
	e:GetHandler():ResetFlagEffect(504700140)
	tc:ResetFlagEffect(504700140+1)
end
function c504700140.retcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() 
end
function c504700140.retop2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	local fid=e:GetLabel()
	local g=Duel.GetMatchingGroup(c504700140.desfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,fid)
	Duel.Destroy(g,REASON_EFFECT)
	if tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_ATTACK) then
		Duel.ChangePosition(tc,POS_FACEUP_ATTACK) 
	elseif tc:GetFlagEffectLabel(504700140+1)==fid and tc:IsPreviousPosition(POS_FACEUP_DEFENSE) then
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end	
	e:GetHandler():ResetFlagEffect(504700140)
	tc:ResetFlagEffect(504700140+1)
end
function c504700140.costfilter(c)
	return c:GetFlagEffect(504700140+2)~=0 and c:IsType(TYPE_TOKEN) 
end
function c504700140.stcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c504700140.costfilter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c504700140.costfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c504700140.stfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c504700140.sttar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c504700140.stfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c504700140.stop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local g=Duel.SelectMatchingCard(tp,c504700140.stfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEDOWN_DEFENSE,true)
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_TOKEN)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_REMOVE_RACE)
		e2:SetValue(RACE_ALL)
		tc:RegisterEffect(e2,true)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
		e3:SetValue(0xff)
		tc:RegisterEffect(e3,true)
		local e4=e1:Clone()
		e4:SetCode(EFFECT_SET_BASE_ATTACK)
		e4:SetValue(0)
		tc:RegisterEffect(e4,true)
		local e5=e1:Clone()
		e5:SetCode(EFFECT_SET_BASE_DEFENSE)
		e5:SetValue(0)
		tc:RegisterEffect(e5,true)
		local e6=Effect.CreateEffect(tc)
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
		--e6:SetValue(c504700140.indval)
		tc:RegisterEffect(e6,true)
		local e7=e1:Clone()
		e7:SetType(EFFECT_TYPE_SINGLE)
		e7:SetCode(EFFECT_CANNOT_ATTACK)
		tc:RegisterEffect(e7,true)
		local e8=e1:Clone()
		e8:SetType(EFFECT_TYPE_SINGLE)
		e8:SetCode(EFFECT_UNRELEASABLE_SUM)
		e8:SetValue(1)
		tc:RegisterEffect(e8,true)
		local e9=e8:Clone()
		e9:SetType(EFFECT_TYPE_SINGLE)
		e9:SetCode(EFFECT_UNRELEASABLE_NONSUM)
		e9:SetValue(1)
		tc:RegisterEffect(e9,true)
		local e10=e1:Clone()
		e10:SetType(EFFECT_TYPE_SINGLE)
		e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e10:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e10:SetValue(1)
		tc:RegisterEffect(e10,true)
		local e11=e1:Clone()
		e11:SetType(EFFECT_TYPE_SINGLE)
		e11:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
		e11:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
		e11:SetValue(1)
		tc:RegisterEffect(e11,true)
		tc:SetStatus(STATUS_NO_LEVEL,true)
		tc:RegisterFlagEffect(504700140+3,RESET_EVENT+0x17a0000,0,0,fid)		
		--Activate set card
		local e20=Effect.CreateEffect(c)
		e20:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e20:SetCode(EVENT_BATTLE_CONFIRM)
		e20:SetRange(LOCATION_SZONE)
		e20:SetLabelObject(tc)
		e20:SetLabel(fid)
		e20:SetCondition(c504700140.actcon1)
		e20:SetOperation(c504700140.actop)
		e20:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e20)
		local e21=Effect.CreateEffect(c)
		e21:SetCategory(CATEGORY_DESTROY)
		e21:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e21:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
		e21:SetRange(LOCATION_SZONE)
		e21:SetCode(EVENT_BECOME_TARGET)
		e21:SetLabelObject(tc)
		e21:SetLabel(fid)
		e21:SetCondition(c504700140.actcon2)
		e21:SetOperation(c504700140.actop)
		e21:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e21)
	local gs1=Duel.GetMatchingGroup(c504700140.gsfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.ChangePosition(gs1,POS_FACEDOWN_DEFENSE)
	Duel.ShuffleSetCard(gs1)
	end
end	
function c504700140.gsfilter(c)
	return c:IsFacedown() and c:GetFlagEffectLabel(504700140+1) or c:GetFlagEffectLabel(504700140+2) or c:GetFlagEffectLabel(504700140+3)
end
function c504700140.actcon1(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsStatus(STATUS_DISABLED) or e:GetHandler():IsDisabled() then return false end
	local d=Duel.GetAttackTarget()
	return d:IsControler(tp) and d:GetFlagEffectLabel(504700140+3)==e:GetLabel() 
end
function c504700140.actcon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsStatus(STATUS_DISABLED) or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local loc,tg=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TARGET_CARDS)
	return rp~=tp and tc and tc:GetFlagEffectLabel(504700140+3)==e:GetLabel() and eg:IsContains(tc)
	and Duel.GetLocationCount(e:GetHandler():GetControler(),LOCATION_SZONE)>0	
end
function c504700140.actop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:GetFlagEffectLabel(504700140+3)==e:GetLabel() and tc:CheckActivateEffect(false,false,false)~=nil then
		local tpe=tc:GetType()
		local te=tc:GetActivateEffect()
		local tg=te:GetTarget()
		local co=te:GetCost()
		local op=te:GetOperation()
		e:SetCategory(te:GetCategory())
		e:SetProperty(te:GetProperty())
	if tc:IsHasEffect(EFFECT_CANNOT_TRIGGER) and tc:GetFlagEffect(78800020)==0 then return false end
		local pre={Duel.GetPlayerEffect(tp,EFFECT_CANNOT_ACTIVATE)}
		if pre[1] then
			for i,eff in ipairs(pre) do
				local prev=eff:GetValue()
				if type(prev)~='function' or prev(eff,te,tp) then return false end
			end
		end
		Duel.ClearTargetCard()
		if bit.band(tpe,TYPE_FIELD)~=0 then
			local fc=Duel.GetFieldCard(1-tp,LOCATION_SZONE,5)
			if Duel.IsDuelType(DUEL_OBSOLETE_RULING) then
				if fc then Duel.Destroy(fc,REASON_RULE) end
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.Destroy(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			else
				fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
				if fc and Duel.SendtoGrave(fc,REASON_RULE)==0 then Duel.SendtoGrave(tc,REASON_RULE) end
			end
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCode())
		tc:CreateEffectRelation(te)
		if bit.band(tpe,TYPE_EQUIP+TYPE_CONTINUOUS+TYPE_FIELD)==0 and not tc:IsHasEffect(EFFECT_REMAIN_FIELD) then
			tc:CancelToGrave(false)
		end
		if te:GetCode()==EVENT_CHAINING then
			local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
			local tc=te2:GetHandler()
			local g=Group.FromCards(tc)
			local p=tc:GetControler()
			if co then co(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
			if tg then tg(te,tp,g,p,chain,te2,REASON_EFFECT,p,1) end
		elseif te:GetCode()==EVENT_FREE_CHAIN then
			if co then co(te,tp,eg,ep,ev,re,r,rp,1) end
			if tg then tg(te,tp,eg,ep,ev,re,r,rp,1) end
		else
			local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
			if co then co(te,tp,teg,tep,tev,tre,tr,trp,1) end
			if tg then tg(te,tp,teg,tep,tev,tre,tr,trp,1) end
		end
		Duel.BreakEffect()
		local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
		if g then
			local etc=g:GetFirst()
			while etc do
				etc:CreateEffectRelation(te)
				etc=g:GetNext()
			end
		end
		tc:SetStatus(STATUS_ACTIVATED,true)
		if not tc:IsDisabled() then
			if te:GetCode()==EVENT_CHAINING then
				local te2=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
				local tc=te2:GetHandler()
				local g=Group.FromCards(tc)
				local p=tc:GetControler()
				if op then op(te,tp,g,p,chain,te2,REASON_EFFECT,p) end
			elseif te:GetCode()==EVENT_FREE_CHAIN then
				if op then op(te,tp,eg,ep,ev,re,r,rp) end
			else
				local res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(te:GetCode(),true)
				if op then op(te,tp,teg,tep,tev,tre,tr,trp) end
			end
		else
			--insert negated animation here
		end
		Duel.RaiseEvent(Group.CreateGroup(tc),EVENT_CHAIN_SOLVED,te,0,tp,tp,Duel.GetCurrentChain())
		if g and tc:IsType(TYPE_EQUIP) and not tc:GetEquipTarget() then
			Duel.Equip(tp,tc,g:GetFirst())
		end
		tc:ReleaseEffectRelation(te)
		if etc then	
			etc=g:GetFirst()
			while etc do
				etc:ReleaseEffectRelation(te)
				etc=g:GetNext()
			end		
		end
	end
end
