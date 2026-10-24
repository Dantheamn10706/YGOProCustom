--無限狂宴
function c120000085.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000085,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetCondition(c120000085.condition)
	e1:SetTarget(c120000085.target)
	e1:SetOperation(c120000085.activate)
	c:RegisterEffect(e1)
	if not c120000085.global_check then
		c120000085.global_check=true
		c120000085[0]=0
		c120000085[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_EQUIP)
		ge1:SetOperation(c120000085.checkop1)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c120000085.clear)
		Duel.RegisterEffect(ge2,0)
	end	
end
function c120000085.checkfilter(c,tp)
	local ec=c:GetEquipTarget()
	return ec and c:IsType(TYPE_SYNCHRO) and c:GetEquipTarget()~=nil or c:IsReason(REASON_LOST_TARGET) 
		and ( ec:IsSetCard(0x3013) or ec:IsCode(63468625) ) and c:GetControler(tp)
end
function c120000085.checkop1(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c120000085.checkfilter,nil,tp)
	if g:GetCount()==0 then return false end
	c120000085[tp]=c120000085[tp]+1
	return true
end
function c120000085.clear(e,tp,eg,ep,ev,re,r,rp)
	c120000085[0]=0
	c120000085[1]=0
end
function c120000085.condition(e,tp,eg,ep,ev,re,r,rp)
	return c120000085[tp]
end
function c120000085.tgfilter(c,tid)
	local ec=c:GetPreviousEquipTarget()
	return c:IsType(TYPE_SYNCHRO) and c:GetTurnID()==tid and c:IsPreviousLocation(LOCATION_SZONE) and ec and ( ec:IsSetCard(0x3013) or ec:IsCode(63468625) )
		and not c:IsReason(REASON_RETURN)
end
function c120000085.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if chk==0 then return ft>0 and Duel.IsExistingTarget(c120000085.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,Duel.GetTurnCount()) end
	local g=Duel.SelectTarget(tp,c120000085.tgfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,ft,ft,nil,Duel.GetTurnCount(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,c120000085[tp]*600)
end
function c120000085.eqfilter(c)
	return c:IsFaceup() and ( c:IsSetCard(0x3013) or c:IsCode(63468625) ) 
end
function c120000085.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(12927849,1))
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c120000085.tgfilter,nil,Duel.GetTurnCount(),e,tp)
	local tg=Duel.SelectMatchingCard(tp,c120000085.eqfilter,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local eq=g:GetFirst()
	while eq do
	if not Duel.Equip(tp,eq,tg,false) then return end
		--Equip limit
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetValue(1)
		eq:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetRange(LOCATION_SZONE)
		e2:SetValue(TYPE_SYNCHRO)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		eq:RegisterEffect(e2)
		eq:RegisterFlagEffect(120000085,RESET_EVENT+0x1fe0000,0,0)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_EQUIP)
		e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_OWNER_RELATE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetValue(c120000085.atkval)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		eq:RegisterEffect(e3,true)
		eq=g:GetNext()		
	end
	Duel.EquipComplete()
	Duel.Damage(1-tp,c120000085[tp]*600,REASON_EFFECT)
	Duel.Recover(tp,600,REASON_EFFECT)
end
function c120000085.eqlimit(e,c)
	return e:GetOwner()==c and not c:IsDisabled()
end
function c120000085.atkval(e,c)
	local atk=0
	local g=c:GetEquipGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:GetFlagEffect(120000085)~=0 and tc:GetAttack()>=0 then
			atk=tc:GetAttack()
		end
		tc=g:GetNext()
	end
	return atk
end