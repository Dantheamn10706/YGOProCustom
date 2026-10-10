--超重武者装留ビッグバン
function c120000093.initial_effect(c)
	--equip
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000093,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(c120000093.eqtg)
	e1:SetOperation(c120000093.eqop)
	c:RegisterEffect(e1)
	--unequip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000093,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTarget(c120000093.sptg)
	e2:SetOperation(c120000093.spop)
	c:RegisterEffect(e2)
	--no damage
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000093,2))
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCondition(c120000093.damcon)
	e3:SetCost(c120000093.damcost)
	e3:SetOperation(c120000093.damop)
	c:RegisterEffect(e3)
end
function c120000093.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x9a)
end
function c120000093.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c120000093.filter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and e:GetHandler():IsType(TYPE_MONSTER)
		and Duel.IsExistingTarget(c120000093.filter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c120000093.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	e:GetHandler():RegisterFlagEffect(120000093,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c120000093.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetValue(c120000093.eqlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(1000)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	c:RegisterEffect(e2)
end
function c120000093.eqlimit(e,c)
	return c:IsSetCard(0x9a)
end
function c120000093.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsType(TYPE_MONSTER) and e:GetHandler():GetFlagEffect(120000093)==0 
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	e:GetHandler():RegisterFlagEffect(120000093,RESET_EVENT+0x7e0000+RESET_PHASE+PHASE_END,0,1)
end
function c120000093.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP_ATTACK)==0 and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0
		and c:IsCanBeSpecialSummoned(e,0,tp,true,false) then
		Duel.SendtoGrave(c,REASON_RULE)
	end
end
function c120000093.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x9a)
end
function c120000093.gfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function c120000093.damcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and aux.damcon1(e,tp,eg,ep,ev,re,r,rp) and e:GetHandler():IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(c120000093.cfilter,tp,LOCATION_MZONE,0,1,nil)
	and not Duel.IsExistingMatchingCard(c120000093.gfilter,tp,LOCATION_GRAVE,0,1,nil)
end
function c120000093.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemoveAsCost() end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_COST)
end
function c120000093.damop(e,tp,eg,ep,ev,re,r,rp)
	local cid=Duel.GetChainInfo(ev,CHAININFO_CHAIN_ID)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetLabel(cid)
	e1:SetValue(c120000093.refcon)
	e1:SetReset(RESET_CHAIN)
	Duel.RegisterEffect(e1,tp)
	Duel.BreakEffect()
		local dg=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,TYPE_MONSTER)
		if Duel.Destroy(dg,REASON_EFFECT)~=0 then 
			local sum=dg:GetSum(Card.GetLevel)
			Duel.Damage(1-tp,sum*100,REASON_EFFECT)
	end		
end
function c120000093.refcon(e,re,val,r,rp,rc)
	local cc=Duel.GetCurrentChain()
	if cc==0 or bit.band(r,REASON_EFFECT)==0 then return end
	local cid=Duel.GetChainInfo(0,CHAININFO_CHAIN_ID)
	if cid==e:GetLabel() then return 0 end
	return val
end