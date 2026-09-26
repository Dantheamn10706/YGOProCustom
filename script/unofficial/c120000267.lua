--ブリリアント・フュージョン
function c120000267.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c120000267.target)
	e1:SetOperation(c120000267.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c120000267.atkcon)
	e2:SetCost(c120000267.atkcost)
	e2:SetTarget(c120000267.atktg)
	e2:SetOperation(c120000267.atkop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetOperation(c120000267.desop)
	c:RegisterEffect(e3)
	--Destroy2
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_SZONE)
	e4:SetCode(EVENT_LEAVE_FIELD)
	e4:SetCondition(c120000267.descon2)
	e4:SetOperation(c120000267.desop2)
	c:RegisterEffect(e4)
	if not AshBlossomTable then AshBlossomTable={} end
	table.insert(AshBlossomTable,e1)
end
function c120000267.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c120000267.filter2(c,e,tp,m,chkf)
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x1047) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
		and c:CheckFusionMaterial(m,nil,chkf) 
end
function c120000267.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg1=Duel.GetMatchingGroup(c120000267.filter1,tp,LOCATION_DECK,0,nil,e)
		local res=Duel.IsExistingMatchingCard(c120000267.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg2=fgroup(ce,e,tp)
				res=Duel.IsExistingMatchingCard(c120000267.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg2,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c120000267.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e)  then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg1=Duel.GetMatchingGroup(c120000267.filter1,tp,LOCATION_DECK,0,nil,e)
	local sg1=Duel.GetMatchingGroup(c120000267.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,chkf)
	local mg2=nil
	local sg2=nil
	local ce=Duel.GetChainMaterial(tp)
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg2=fgroup(ce,e,tp)
		sg2=Duel.GetMatchingGroup(c120000267.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg2,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then sg:Merge(sg2) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,nil,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			if Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)==0 then return end
			e:GetHandler():SetCardTarget(tc)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(0)
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_SET_DEFENCE_FINAL)
			tc:RegisterEffect(e2)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg2,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
		
	end
end
function c120000267.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFirstCardTarget()
end
function c120000267.cfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function c120000267.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c120000267.cfilter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,c120000267.cfilter,1,1,REASON_COST+REASON_DISCARD,nil)
end
function c120000267.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetFirstCardTarget() end
end
function c120000267.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(tc:GetBaseAttack())
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_STANDBY,2)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetValue(tc:GetBaseDefense())
	tc:RegisterEffect(e2)
end
function c120000267.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c120000267.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c120000267.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end

