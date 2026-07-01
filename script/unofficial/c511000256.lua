--オレイカルコスの結界
function c511000256.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetDescription(aux.Stringid(511000256,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c511000256.actcost)
	e1:SetTarget(c511000256.acttg)
	e1:SetOperation(c511000256.actop)
	c:RegisterEffect(e1)
	--ATK Up
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--Cannot disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_DISABLE)
	c:RegisterEffect(e3)
	--Immune 
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c511000256.indval)
	c:RegisterEffect(e4)
	--Move Monsters to Spell/Trap Zone
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(5012,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_FZONE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCountLimit(1)
	e5:SetTarget(c511000256.sntg)
	e5:SetOperation(c511000256.snpop)
	c:RegisterEffect(e5)
	--Move Monsters to Monsters Zone
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(5012,1))
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_FZONE)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetTarget(c511000256.sttg)
	e7:SetOperation(c511000256.stop)
	c:RegisterEffect(e7)
end
function c511000256.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,48179391)==0 end
	Duel.RegisterFlagEffect(tp,48179391,0,0,0)
end
function c511000256.desfilter(c)
	return c:IsDestructable() and (c.hermos_filter or c.material_race or aux.IsMaterialListCode(c,1784686) 
		or aux.IsMaterialListCode(c,46232525) or aux.IsMaterialListCode(c,11082056) or c.material_trap)
end
function c511000256.mgfilter(c,code)
	return c:IsType(TYPE_TRAP) and code and c:IsCode(code)
end
function c511000256.mgfilter2(c,e,tp,fusc)
	return bit.band(c:GetReason(),0x40008)==0x40008 and c:IsType(TYPE_TRAP) and c:IsSSetable()
end
function c511000256.acttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c511000256.desfilter,tp,LOCATION_ONFIELD,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c511000256.actop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c511000256.desfilter,tp,LOCATION_ONFIELD,0,nil)
	local sg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetReasonEffect() then
			if tc:GetReasonEffect():GetHandler():IsCode(11082056) then
				local code=tc.material_trap
				local mc=Duel.GetFirstMatchingCard(c511000256.mgfilter,tp,LOCATION_GRAVE,0,nil,code)
				sg:AddCard(mc)
			elseif tc:GetReasonEffect():GetHandler():IsCode(1784686) then
				local mg=tc:GetMaterial()
				mg:Remove(Card.IsCode,nil,1784686)
				sg:Merge(mg)
			end
		end
		tc=g:GetNext()
	end
	Duel.Destroy(g,REASON_EFFECT)
	local mc=sg:GetFirst()
	while mc do
		if mc:IsType(TYPE_MONSTER) then
			Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEUP,true)
			mc:SetStatus(STATUS_SPSUMMON_TURN,true)
		else
			Duel.MoveToField(mc,tp,tp,LOCATION_MZONE,POS_FACEDOWN,true)
		end
	end
end
function c511000256.indval(e,re)
	return not re:GetHandler():IsCode(89397517)
end
function c511000256.smfilter(c)
	return c:GetFlagEffect(511000256)==0 and c:GetFlagEffect(5110002565)==0
end
function c511000256.sntg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c511000256.smfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511000256.smfilter,tp,LOCATION_MZONE,0,1,nil) and ft>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c511000256.smfilter,tp,LOCATION_MZONE,0,1,ft,nil)
end
function c511000256.snpop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if ft<=0 then return end
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local gc=g:GetCount()
	if gc>ft then return end
	local tc=g:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_NORMAL) 
			and not tc:IsType(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e1=Effect.CreateEffect(tc)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetRange(LOCATION_SZONE)
			e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
			e1:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e1) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_EFFECT) 
			and not tc:IsType(TYPE_FUSION+TYPE_RITUAL+TYPE_SYNCHRO+TYPE_XYZ+TYPE_PENDULUM+TYPE_LINK) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e2=Effect.CreateEffect(tc)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_CHANGE_TYPE)
			e2:SetRange(LOCATION_SZONE)
			e2:SetValue(TYPE_EFFECT+TYPE_MONSTER)
			e2:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e2) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_FUSION) and not tc:IsType(TYPE_EFFECT) then	
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e3=Effect.CreateEffect(tc)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_CHANGE_TYPE)
			e3:SetRange(LOCATION_SZONE)
			e3:SetValue(TYPE_FUSION+TYPE_MONSTER)
			e3:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e3) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_FUSION) and tc:IsType(TYPE_EFFECT) then	
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e4=Effect.CreateEffect(tc)
			e4:SetType(EFFECT_TYPE_SINGLE)
			e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e4:SetCode(EFFECT_CHANGE_TYPE)
			e4:SetRange(LOCATION_SZONE)
			e4:SetValue(TYPE_FUSION+TYPE_EFFECT+TYPE_MONSTER)
			e4:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e4) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_RITUAL) and not tc:IsType(TYPE_EFFECT) then	
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e5=Effect.CreateEffect(tc)
			e5:SetType(EFFECT_TYPE_SINGLE)
			e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e5:SetCode(EFFECT_CHANGE_TYPE)
			e5:SetRange(LOCATION_SZONE)
			e5:SetValue(TYPE_RITUAL+TYPE_MONSTER)
			e5:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e5) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_RITUAL) and tc:IsType(TYPE_EFFECT) then	
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e6=Effect.CreateEffect(tc)
			e6:SetType(EFFECT_TYPE_SINGLE)
			e6:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e6:SetCode(EFFECT_CHANGE_TYPE)
			e6:SetRange(LOCATION_SZONE)
			e6:SetValue(TYPE_RITUAL+TYPE_EFFECT+TYPE_MONSTER)
			e6:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e6) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_SYNCHRO) and not tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e7=Effect.CreateEffect(tc)
			e7:SetType(EFFECT_TYPE_SINGLE)
			e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e7:SetCode(EFFECT_CHANGE_TYPE)
			e7:SetRange(LOCATION_SZONE)
			e7:SetValue(TYPE_SYNCHRO+TYPE_MONSTER)
			e7:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e7) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_SYNCHRO) and tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e8=Effect.CreateEffect(tc)
			e8:SetType(EFFECT_TYPE_SINGLE)
			e8:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e8:SetCode(EFFECT_CHANGE_TYPE)
			e8:SetRange(LOCATION_SZONE)
			e8:SetValue(TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
			e8:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e8) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_SYNCHRO) and not tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e9=Effect.CreateEffect(tc)
			e9:SetType(EFFECT_TYPE_SINGLE)
			e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e9:SetCode(EFFECT_CHANGE_TYPE)
			e9:SetRange(LOCATION_SZONE)
			e9:SetValue(TYPE_SYNCHRO+TYPE_MONSTER)
			e9:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e9) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_SYNCHRO) and tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e10=Effect.CreateEffect(tc)
			e10:SetType(EFFECT_TYPE_SINGLE)
			e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e10:SetCode(EFFECT_CHANGE_TYPE)
			e10:SetRange(LOCATION_SZONE)
			e10:SetValue(TYPE_SYNCHRO+TYPE_EFFECT+TYPE_MONSTER)
			e10:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e10) end		
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) and not tc:IsType(TYPE_EFFECT) then	
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e11=Effect.CreateEffect(tc)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e11:SetCode(EFFECT_CHANGE_TYPE)
			e11:SetRange(LOCATION_SZONE)
			e11:SetValue(TYPE_XYZ+TYPE_MONSTER)
			e11:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e11) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_XYZ) and tc:IsType(TYPE_EFFECT) then	
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e12=Effect.CreateEffect(tc)
			e12:SetType(EFFECT_TYPE_SINGLE)
			e12:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e12:SetCode(EFFECT_CHANGE_TYPE)
			e12:SetRange(LOCATION_SZONE)
			e12:SetValue(TYPE_XYZ+TYPE_EFFECT+TYPE_MONSTER)
			e12:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e12) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_PENDULUM) and not tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e13=Effect.CreateEffect(tc)
			e13:SetType(EFFECT_TYPE_SINGLE)
			e13:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e13:SetCode(EFFECT_CHANGE_TYPE)
			e13:SetRange(LOCATION_SZONE)
			e13:SetValue(TYPE_PENDULUM+TYPE_MONSTER)
			e13:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e13) end
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_PENDULUM) and tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e14=Effect.CreateEffect(tc)
			e14:SetType(EFFECT_TYPE_SINGLE)
			e14:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e14:SetCode(EFFECT_CHANGE_TYPE)
			e14:SetRange(LOCATION_SZONE)
			e14:SetValue(TYPE_PENDULUM+TYPE_EFFECT+TYPE_MONSTER)
			e14:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e14) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_LINK) and not tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e15=Effect.CreateEffect(tc)
			e15:SetType(EFFECT_TYPE_SINGLE)
			e15:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e15:SetCode(EFFECT_CHANGE_TYPE)
			e15:SetRange(LOCATION_SZONE)
			e15:SetValue(TYPE_LINK+TYPE_MONSTER)
			e15:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e15) end	
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:IsType(TYPE_LINK) and tc:IsType(TYPE_EFFECT) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
			local e16=Effect.CreateEffect(tc)
			e16:SetType(EFFECT_TYPE_SINGLE)
			e16:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e16:SetCode(EFFECT_CHANGE_TYPE)
			e16:SetRange(LOCATION_SZONE)
			e16:SetValue(TYPE_LINK+TYPE_EFFECT+TYPE_MONSTER)
			e16:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e16) end		
		tc:RegisterFlagEffect(511000257,RESET_EVENT+0x1fe0000,0,0)
		tc:RegisterFlagEffect(511000256,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		if tc:IsLocation(LOCATION_MZONE) and tc:IsFacedown() and tc:IsType(TYPE_MONSTER) then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true)
			local e17=Effect.CreateEffect(tc)
			e17:SetType(EFFECT_TYPE_SINGLE)
			e17:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e17:SetCode(EFFECT_CHANGE_TYPE)
			e17:SetRange(LOCATION_SZONE)
			e17:SetValue(TYPE_MONSTER)
			e17:SetReset(RESET_EVENT+0x1fc0000)
			tc:RegisterEffect(e17)
			tc:RegisterFlagEffect(511000257,RESET_EVENT+0x1fe0000,0,0)
			tc:RegisterFlagEffect(511000256,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		end
		tc=g:GetNext()	
	end
end
function c511000256.stfilter(c)
	return c:GetFlagEffect(511000256)==0 and c:GetFlagEffect(511000257)>0 and c:GetFlagEffect(5110002565)==0
end
function c511000256.sttg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chkc then return chkc:IsLocation(LOCATION_SZONE) and c511000256.stfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c511000256.stfilter,tp,LOCATION_SZONE,0,1,nil) and ft>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectTarget(tp,c511000256.stfilter,tp,LOCATION_SZONE,0,1,ft,nil)
end
function c511000256.stop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	local gc=sg:GetCount()
	if gc>ft then return end
	local tc=sg:GetFirst()
	while tc do
		if tc:IsLocation(LOCATION_SZONE) and tc:IsFaceup() and Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEUP,true) then
			tc:RegisterFlagEffect(5110002565,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
		elseif tc:IsLocation(LOCATION_SZONE) and tc:IsFacedown() then
			Duel.MoveToField(tc,tp,tp,LOCATION_MZONE,POS_FACEDOWN,true)
			tc:RegisterFlagEffect(5110002565,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,0)
			end
		tc=sg:GetNext()	
	end
end
