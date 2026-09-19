--デュエリスト・キングダム 
function c120000071.initial_effect(c)
	aux.EnableExtraRules(c,c120000071,c120000071.init)
end
function c120000071.init(c)
	--Terrains
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_ADJUST)
	e1:SetCountLimit(1)
	e1:SetCondition(c120000071.con)
	e1:SetOperation(c120000071.op)
	Duel.RegisterEffect(e1,0)
	--decrease tribute
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000071,1))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	e2:SetCondition(c120000071.ntcon)
	e2:SetTarget(c120000071.nttg)
	Duel.RegisterEffect(e2,0)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	e3:SetTarget(c120000071.nttg2)
	Duel.RegisterEffect(e3,0)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_LIMIT_SUMMON_PROC)
	e4:SetTarget(c120000071.nttg3)
	Duel.RegisterEffect(e4,0)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_LIMIT_SET_PROC)
	e5:SetTarget(c120000071.nttg4)
	Duel.RegisterEffect(e5,0)
	--summon face-up defense
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_LIGHT_OF_INTERVENTION)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetTargetRange(1,1)
	Duel.RegisterEffect(e6,0)
	--cannot direct attack
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
	e7:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e7,0)
	--cannot attack
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
	e8:SetRange(LOCATION_REMOVED)
	e8:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e8:SetCondition(c120000071.atkcon)
	e8:SetTarget(c120000071.atktg)
	Duel.RegisterEffect(e8,0)
	--check
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e9:SetCode(EVENT_ATTACK_ANNOUNCE)
	e9:SetRange(LOCATION_REMOVED)
	e9:SetOperation(c120000071.checkop)
	e9:SetLabelObject(e8)
	Duel.RegisterEffect(e9,0)
	--Set Spell cards can activate in opponent's turn
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetCode(EFFECT_BECOME_QUICK)
	e10:SetRange(LOCATION_REMOVED)
	e10:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	Duel.RegisterEffect(e10,0)
	--Machine Inmunity 
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD)
	e11:SetRange(LOCATION_REMOVED)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e11:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_MACHINE))
	e11:SetValue(c120000071.efilter)
	Duel.RegisterEffect(e11,0)
end
function c120000071.con(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFieldCard(LOCATION_SZONE,0,5)
	if tc and tc:IsFaceup() then return false end
	tc=Duel.GetFieldCard(1,LOCATION_SZONE,5)
	return not tc and Duel.GetTurnCount()==1
end
function c120000071.code(c)
	local res={}
	if c:IsCode(316000205) then table.insert(res,1) end
	if c:IsCode(316000206) then table.insert(res,2) end
	if c:IsCode(316000207) then table.insert(res,4) end
	if c:IsCode(316000208) then table.insert(res,5) end
	if c:IsCode(316000209) then table.insert(res,7) end
	if c:IsCode(316000210) then table.insert(res,8) end
	return res
end
function update_table(global_table,c)
	local tmp_table={}
	local arch_lst=c120000071.code(c)
	for _,ar in ipairs(arch_lst) do
		for __,chk in ipairs(global_table) do
			if (ar&chk)==0 then
				table.insert(tmp_table,ar|chk)
			end
		end
	end
	return tmp_table
end
function c120000071.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tf=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	if tf==nil and not Duel.SelectYesNo(1-tp,aux.Stringid(120000071,0)) or not Duel.SelectYesNo(tp,aux.Stringid(120000071,0)) then
	local tr_tab={}
	tr_tab=update_table(tr_tab)
	local ac=Duel.AnnounceCard(tp,table.unpack(tr_tab))
		--Move the Terrain Spell Card to the field and place them in the Field Zone
		local token=Duel.CreateToken(tp,ac,nil,nil,nil,nil,nil,nil)		
		Duel.SpecialSummonStep(token,0,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(c)
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(TYPE_SPELL+TYPE_FIELD)
		e1:SetReset(RESET_EVENT+0x1fc0000)
		token:RegisterEffect(e1)
		Duel.MoveToField(token,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		Duel.SpecialSummonComplete()	
	end
	tableTerr = {
	316000205,
	316000206,
	316000207,
	316000208,
	316000209,
	316000210,
	}
end
function c120000071.ntcon(e,c,minc)
	if c==nil then return true end
	local _,max=c:GetTributeRequirement()
	return minc==0 and max>0 and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c120000071.nttg(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071)==0
end
function c120000071.nttg2(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071+1)==0
end
function c120000071.nttg3(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071)~=0
end
function c120000071.nttg4(e,c)
	return c==0 or c==1 or c:GetFlagEffect(120000071+1)~=0
end
function c120000071.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsPosition(POS_FACEDOWN_DEFENSE)
end
function c120000071.ctcon2(e,re)
	return re:GetHandler()~=e:GetHandler()
end
function c120000071.atkcon(e)
	return e:GetHandler():GetFlagEffect(120000071)~=0
end
function c120000071.atktg(e,c)
	return c:GetFieldID()~=e:GetLabel()
end
function c120000071.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(120000071)~=0 then return end
	local fid=eg:GetFirst():GetFieldID()
	e:GetHandler():RegisterFlagEffect(120000071,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	e:GetLabelObject():SetLabel(fid)
end
function c120000071.efilter(e,re,rp)
	return re:GetOwnerPlayer()~=e:GetHandlerPlayer() and re:IsActiveType(TYPE_SPELL) and re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) 
	and Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
end
