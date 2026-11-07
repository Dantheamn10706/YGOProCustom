--ラーの翼神竜 (Anime)
--The Winged Dragon of Ra (Anime)
--Scripted by Larry126
--Modified: Attack goes to 0 when diffusion is activated
Duel.EnableUnofficialProc(PROC_RA_DEFUSION)
local s,id=GetID()
function s.initial_effect(c)
	-- Summon with 3 Tribute
	aux.AddNormalSummonProcedure(c,true,false,3,3)
	aux.AddNormalSetProcedure(c,true,false,3,3)

	-- Destroy Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_EQUIP)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)

	-- Control of this card cannot switch
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)

	-- Effect immunity (except DIVINE monsters)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)

	-- Opponent cannot Tribute/Release this card
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,1) -- opponent only
	e4:SetTarget(function(e,tc) return tc==e:GetHandler() end)
	c:RegisterEffect(e4)

	-- Opponent cannot use this card as Fusion/Synchro/Xyz/Link material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,1) -- opponent only
	e5:SetTarget(function(e,tc) return tc==e:GetHandler() end)
	e5:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_SYNCHRO,SUMMON_TYPE_XYZ,SUMMON_TYPE_LINK))
	c:RegisterEffect(e5)

	-- Last for 1 turn & block
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_TURN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetOperation(s.stgop)
	c:RegisterEffect(e6)

	-- Special Summon check
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetOperation(s.spchk)
	c:RegisterEffect(e7)

	-- Stats when Normal Summoned
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetCode(EFFECT_MATERIAL_CHECK)
	e8:SetValue(s.valcheck)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_SUMMON_COST)
	e9:SetOperation(function() e8:SetLabel(1) end)
	c:RegisterEffect(e9)

	-- Unstoppable Attack
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE)
	e10:SetCode(EFFECT_UNSTOPPABLE_ATTACK)
	e10:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetCondition(function(e) return e:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL) end)
	c:RegisterEffect(e10)

	-- Point-to-Point Transfer
	local e11=Effect.CreateEffect(c)
	e11:SetDescription(aux.Stringid(id,0))
	e11:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e11:SetType(EFFECT_TYPE_IGNITION)
	e11:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e11:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCost(s.payatkcost)
	e11:SetOperation(s.payatkop)
	c:RegisterEffect(e11)

	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(id,0))
	e12:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e12:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e12:SetCode(EVENT_SPSUMMON_SUCCESS)
	e12:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DELAY)
	e12:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e12:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) end)
	e12:SetCost(s.payatkcost)
	e12:SetTarget(function(e,_,_,_,_,_,_,_,chk) if chk==0 then return e:GetHandler():IsOnField() end end)
	e12:SetOperation(s.payatkop)
	c:RegisterEffect(e12)

	-- Immortal Phoenix
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(id,1))
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetCode(EVENT_SPSUMMON_SUCCESS)
	e13:SetProperty(EFFECT_FLAG_NO_TURN_RESET+EFFECT_FLAG_DELAY)
	e13:SetCountLimit(1,0,EFFECT_COUNT_CODE_SINGLE)
	e13:SetCondition(function(e) return e:GetHandler():IsPreviousLocation(LOCATION_GRAVE) end)
	e13:SetTarget(function(e,_,_,_,_,_,_,_,chk) if chk==0 then return e:GetHandler():IsOnField() end end)
	e13:SetOperation(s.egpop)
	c:RegisterEffect(e13)

	-- Effect to monitor changes
	local e14=Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_ADJUST)
	e14:SetRange(LOCATION_MZONE)
	e14:SetOperation(s.adjustop)
	c:RegisterEffect(e14)
end


-- Helper function to check if Ra's baseline was set to 4000 by card 10000080
function s.isRaModifiedBy10000080(c)
	-- Check if Ra's base ATK and DEF are both 4000 (the effect of card 10000080)
	-- AND if card 10000080 is in the graveyard (meaning it was used)
	local has4000Stats = c:GetBaseAttack() == 4000 and c:GetBaseDefense() == 4000
	local card10000080InGY = Duel.IsExistingMatchingCard(function(card)
		return card:IsCode(10000080)
	end, c:GetControler(), LOCATION_GRAVE, 0, 1, nil)
	
	return has4000Stats and card10000080InGY
end

-- Helper function to check if card 10000080 is preventing resets
function s.isPersistentModeActive(tp)
	return Duel.IsExistingMatchingCard(function(card)
		return card:IsFaceup() and card:IsCode(10000080)
	end, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, 1, nil)
end

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	-- COMMENTED OUT TO TEST
	--[[
	local c=e:GetHandler()
	if c:GetAttack() ~= c:GetBaseAttack() or c:GetDefense() ~= c:GetBaseDefense() or c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) then
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
	--]]
end

function s.resetCondition(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	-- Only reset if it's the controller's turn AND Ra wasn't modified by 10000080
	return Duel.GetTurnPlayer() == tp and not s.isRaModifiedBy10000080(c)
end

function s.resetOriginalStatsOperation(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()
	if not c or not c:IsLocation(LOCATION_MZONE) or not c:IsFaceup() then return end

	-- Get the base ATK/DEF values (these are Ra's original stats)
	local baseAtk = c:GetBaseAttack()
	local baseDef = c:GetBaseDefense()
	
	-- Only reset if current stats differ from base stats
	if c:GetAttack() ~= baseAtk then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetValue(baseAtk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
	
	if c:GetDefense() ~= baseDef then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
		e2:SetValue(baseDef)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
	end
end

function s.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Destroy(eg:Filter(function(ec) return ec:GetEquipTarget()==c end,nil),REASON_EFFECT)
end

function s.leaveChk(c,category)
	local ex,tg=Duel.GetOperationInfo(0,category)
	return ex and tg~=nil and tg:IsContains(c)
end

-- Ra - The Winged Dragon (c513000134.lua)
-- Updated s.efilter function for Ra
function s.efilter(e,te)
	local c = e:GetHandler()
	local tc = te:GetOwner()
	local tp = te:GetHandlerPlayer()
	-- Check if the effect is from an opponent
	if tp ~= e:GetHandlerPlayer() then
		-- Allow effects from DIVINE monsters
		if te:IsActiveType(TYPE_MONSTER) and tc:IsOriginalAttribute(ATTRIBUTE_DIVINE) then
			return false
		end
		-- Block targeting by opponent's card effects
		if te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
			return true
		end
		-- Blocks being targeted or destroyed by other card effects
		if (te:IsActiveType(TYPE_SPELL + TYPE_TRAP + TYPE_MONSTER) and
			(te:GetCategory() & (CATEGORY_DESTROY + CATEGORY_TOHAND + CATEGORY_TODECK + CATEGORY_TOGRAVE)) ~= 0) then
			return true
		end
	end
	return false
end

function s.stgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	-- Check if Ra's baseline is 4000/4000 due to card 10000080
	if s.isRaModifiedBy10000080(c) then
		-- Reset to 4000/4000 instead of original stats
		if c:GetAttack() ~= 4000 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SET_ATTACK_FINAL)
			e1:SetValue(4000)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e1)
		end
		if c:GetDefense() ~= 4000 then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_SET_DEFENSE_FINAL)
			e2:SetValue(4000)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			c:RegisterEffect(e2)
		end
		-- Don't reset other effects if baseline is 4000
		return
	end
	
	-- Normal reset behavior for non-4000 baseline
	local effs={c:GetCardEffect()}
	for _,eff in ipairs(effs) do
		if eff:GetOwner()~=c and not eff:GetOwner():IsCode(0)
			and not eff:IsHasProperty(EFFECT_FLAG_IGNORE_IMMUNE) and eff:GetCode()~=EFFECT_SPSUMMON_PROC
			and (eff:GetTarget()==aux.PersistentTargetFilter or not eff:IsHasType(EFFECT_TYPE_GRANT+EFFECT_TYPE_FIELD)) then
			eff:Reset()
		end
	end
end

function s.spchk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if re and (re:IsSpellEffect() or re:IsMonsterEffect()) then
		local prevCtrl=c:GetPreviousControler()
		aux.DelayedOperation(c,PHASE_END,id,e,tp,function()
			if c:IsPreviousLocation(LOCATION_GRAVE) then
				Duel.SendtoGrave(c,REASON_EFFECT,prevCtrl)
			elseif c:IsPreviousLocation(LOCATION_REMOVED) then
				Duel.Remove(c,c:GetPreviousPosition(),REASON_EFFECT,prevCtrl)
			elseif c:GetPreviousLocation()==0 then
				Duel.RemoveCards(c)
			end
		end,nil,0)
	end
	if c:IsAttackPos() then return end
	local ac=Duel.GetAttacker()
	if Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and ac:CanAttack()
		and ac:GetAttackableTarget():IsContains(c)
		and Duel.SelectEffectYesNo(tp,c,aux.Stringid(68823957,0)) then
		Duel.HintSelection(c,true)
		Duel.ChangeAttackTarget(c)
	end
	local te,tg=Duel.GetChainInfo(ev+1,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TARGET_CARDS)
	if te and te~=re and te:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and #tg==1
		and c:IsCanBeEffectTarget(te) and Duel.SelectEffectYesNo(tp,c,aux.Stringid(68823957,1)) then
		Duel.ChangeTargetCard(ev+1,Group.FromCards(c))
	end
end

-------------------------------------------
--Stats When Normal Summoned
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	local atk=0
	local def=0
	for tc in mg:Iter() do
		local catk=tc:GetAttack()
		local cdef=tc:GetDefense()
		atk=atk+(catk>=0 and catk or 0)
		def=def+(cdef>=0 and cdef or 0)
	end
	if e:GetLabel()==1 then
		e:SetLabel(0)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD&~RESET_TOFIELD)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENSE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end

-------------------------------------------
--Point-to-Point Transfer
function s.payatkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local lpCost=Duel.GetLP(tp)-1
	if chk==0 then return lpCost>0 and Duel.CheckLPCost(tp,lpCost) end
	e:SetLabel(lpCost)
	Duel.PayLPCost(tp,lpCost)
end

function s.payatkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not (c:IsRelateToEffect(e) and c:IsFaceup()) then return end
	local lp=e:GetLabel()

	-- Check if persistent effects should be used (Ra was modified by 10000080)
	local isPersistent = s.isRaModifiedBy10000080(c)
	local reset_flag = isPersistent and (RESET_EVENT|RESETS_STANDARD) or (RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)

	--Set ATK/DEF to 0 initially, then add LP as UPDATE (MODIFIED)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_BASE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.dfcon)
	e1:SetValue(0)  -- Set base to 0
	e1:SetReset(reset_flag)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_BASE_DEFENSE)
	e2:SetValue(0)  -- Set base to 0
	c:RegisterEffect(e2)
	
	--Immediately add the LP as attack/defense increase
	local e1b=Effect.CreateEffect(c)
	e1b:SetType(EFFECT_TYPE_SINGLE)
	e1b:SetCode(EFFECT_UPDATE_ATTACK)
	e1b:SetCondition(s.dfcon)
	e1b:SetValue(lp)  -- Add the LP paid as attack
	e1b:SetReset(reset_flag)
	c:RegisterEffect(e1b)
	local e2b=e1b:Clone()
	e2b:SetCode(EFFECT_UPDATE_DEFENSE)
	e2b:SetValue(lp)  -- Add the LP paid as defense
	c:RegisterEffect(e2b)

	--Treated as Fusion
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_ADD_TYPE)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(s.dfcon)
	e3:SetValue(TYPE_FUSION)
	e3:SetReset(reset_flag)
	c:RegisterEffect(e3)

	--Tribute for stats
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.dfcon)
	e4:SetCost(s.tatkcost)
	e4:SetOperation(s.tatkop)
	e4:SetReset(reset_flag)
	c:RegisterEffect(e4)

	--LP is stats
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_RECOVER)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(s.dfcon)
	e5:SetOperation(s.atkop1)
	e5:SetReset(reset_flag)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_END)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.dfcon)
	e6:SetOperation(s.atkop2)
	e6:SetReset(reset_flag)
	c:RegisterEffect(e6)

	--Attack all
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_MZONE)
	e7:SetTargetRange(0,LOCATION_MZONE)
	e7:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e7:SetCondition(s.dfcon)
	e7:SetTarget(function(_e,_c) return _c:GetFlagEffect(id+100)>0 end)
	e7:SetValue(function(_e,_c) return _c==_e:GetHandler() end)
	e7:SetReset(reset_flag)
	c:RegisterEffect(e7)

	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(EVENT_DAMAGE_STEP_END)
	e8:SetCondition(s.dfcon)
	e8:SetOperation(s.dirop)
	e8:SetReset(reset_flag)
	c:RegisterEffect(e8)

	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetCode(EFFECT_EXTRA_ATTACK)
	e9:SetValue(9999)
	e9:SetCondition(s.dfcon)
	e9:SetReset(reset_flag)
	c:RegisterEffect(e9)

	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_DAMAGE_STEP_END)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e10:SetCondition(s.dfcon)
	e10:SetOperation(s.unop)
	e10:SetReset(reset_flag)
	c:RegisterEffect(e10)
end

function s.dfcon(e)
	if e:GetHandler():HasFlagEffect(FLAG_RA_DEFUSION) then
		e:Reset()
		return false
	end
	return true
end

function s.atkop1(e,tp,eg,ep,ev,re,r,rp)
	if ep==1-tp then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local isPersistent = s.isPersistentModeActive(tp)
	local reset_flag = isPersistent and (RESET_EVENT|RESETS_STANDARD) or (RESET_EVENT|RESETS_STANDARD)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.dfcon)
	e1:SetValue(ev)
	e1:SetReset(reset_flag)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	Duel.SetLP(tp,1,REASON_EFFECT)
end

function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local lp=Duel.GetLP(tp)
	if lp<=1 then return end
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local isPersistent = s.isPersistentModeActive(tp)
	local reset_flag = isPersistent and (RESET_EVENT|RESETS_STANDARD) or (RESET_EVENT|RESETS_STANDARD)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_COPY_INHERIT)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.dfcon)
	e1:SetValue(lp-1)
	e1:SetReset(reset_flag)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	Duel.SetLP(tp,1,REASON_EFFECT)
end

function s.tatkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroupCost(tp,nil,1,false,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroupCost(tp,nil,1,99,false,nil,e:GetHandler())
	local suma=0
	local sumd=0
	for tc in g:Iter() do
		suma=suma+tc:GetAttack()
		sumd=sumd+tc:GetDefense()
	end
	e:SetLabel(suma,sumd)
	Duel.Release(g,REASON_COST)
end

function s.tatkop(e,tp,eg,ep,ev,re,r,rp)
	if not s.dfcon(e) then return end
	local c=e:GetHandler()
	local atk,def=e:GetLabel()
	local isPersistent = s.isPersistentModeActive(e:GetHandlerPlayer())
	local reset_flag = isPersistent and (RESET_EVENT|RESETS_STANDARD) or (RESET_EVENT|RESETS_STANDARD)
	
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetCondition(s.dfcon)
	e1:SetValue(atk)
	e1:SetReset(reset_flag)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	e2:SetCondition(s.dfcon)
	e2:SetValue(def)
	e2:SetReset(reset_flag)
	c:RegisterEffect(e2)
end

function s.unop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc and bc:IsRelateToBattle() then
		bc:RegisterFlagEffect(id+100,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE,0,1)
	end
end

function s.dirop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.GetAttackTarget() then
		local c=e:GetHandler()
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
		e1:SetCondition(s.dfcon)
		e1:SetReset(RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end

-------------------------------------------
--God Phoenix
function s.egpop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local isPersistent = s.isPersistentModeActive(tp)
		local reset_flag = isPersistent and (RESET_EVENT|RESETS_STANDARD) or (RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_END)
		
		--Immunities
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(1)
		e1:SetReset(reset_flag)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_IMMUNE_EFFECT)
		e2:SetValue(s.imfilter)
		c:RegisterEffect(e2)
		local e3=e1:Clone()
		e3:SetCode(EFFECT_CANNOT_BE_MATERIAL)
		e3:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_RITUAL))
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
		e4:SetValue(1)
		e4:SetReset(reset_flag)
		c:RegisterEffect(e4)
		--Send to Graveyard
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(id,3))
		e5:SetCategory(CATEGORY_TOGRAVE)
		e5:SetType(EFFECT_TYPE_QUICK_O)
		e5:SetCode(EVENT_FREE_CHAIN)
		e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e5:SetRange(LOCATION_MZONE)
		e5:SetCondition(s.tgcon)
		e5:SetCost(s.tgcost)
		e5:SetTarget(s.tgtg)
		e5:SetOperation(s.tgop)
		e5:SetReset(reset_flag)
		c:RegisterEffect(e5)
	end
end

function s.imfilter(e,te)
	local c=e:GetOwner()
	return (c:GetDestination()>0 and c:GetReasonEffect()==te)
		or (s.leaveChk(c,CATEGORY_TOHAND) or s.leaveChk(c,CATEGORY_DESTROY) or s.leaveChk(c,CATEGORY_REMOVE)
		or s.leaveChk(c,CATEGORY_TODECK) or s.leaveChk(c,CATEGORY_RELEASE) or s.leaveChk(c,CATEGORY_TOGRAVE))
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsHasEffect(EFFECT_UNSTOPPABLE_ATTACK) or (not c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		and not c:IsHasEffect(EFFECT_FORBIDDEN) and not c:IsHasEffect(EFFECT_CANNOT_ATTACK)
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ATTACK_ANNOUNCE)
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ATTACK))
end

function s.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end

function s.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc~=e:GetHandler() end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
end

function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end