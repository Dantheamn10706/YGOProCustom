--オシリスの天空竜 (Anime)
--Slifer the Sky Dragon (Anime)
--Scripted by Larry126
local s,id=GetID()
function s.initial_effect(c)
	--Summon with 3 Tribute
	aux.AddNormalSummonProcedure(c,true,false,3,3)
	aux.AddNormalSetProcedure(c,true,false,3,3)
	--Destroy Equip
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_EQUIP)
	e1:SetOperation(s.eqop)
	c:RegisterEffect(e1)
	--Control of this card cannot switch
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	c:RegisterEffect(e2)
	--Effect immunity
	local e3=e2:Clone()
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetValue(s.efilter)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_MATERIAL)
	e4:SetValue(aux.cannotmatfilter(SUMMON_TYPE_FUSION,SUMMON_TYPE_RITUAL))
	c:RegisterEffect(e4)
	--Last for 1 turn & block
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_TURN_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetOperation(s.stgop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetOperation(s.spchk)
	c:RegisterEffect(e6)
	--Race "Dragon"
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_ADD_RACE)
	e7:SetValue(RACE_DRAGON)
	c:RegisterEffect(e7)
	--X000
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e8:SetCode(513000136)
	c:RegisterEffect(e8)
	--Gain ATK/DEF
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_MZONE)
	e9:SetCode(EFFECT_SET_BASE_ATTACK)
	e9:SetCondition(function(e) return e:GetHandler():IsHasEffect(513000136) end)
	e9:SetValue(s.adval)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(e10)
	--Summon Thunder Bullet
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE+CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(s.atkcon)
	e6:SetTarget(s.atktg)
	e6:SetOperation(s.atkop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e8)
	-- Effect to monitor changes
	local e13 = Effect.CreateEffect(c)
	e13:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e13:SetCode(EVENT_ADJUST)
	e13:SetRange(LOCATION_MZONE)
	e13:SetOperation(s.adjustop)
	c:RegisterEffect(e13)
	-- Reset effects at the end of the turn using e14 as the effect identifier
	local e14 = Effect.CreateEffect(c)
	e14:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_CONTINUOUS)
	e14:SetCode(EVENT_TURN_END)
	e14:SetRange(LOCATION_MZONE)
	e14:SetCountLimit(1)
	e14:SetCondition(s.resetCondition)
	e14:SetOperation(s.resetOriginalStatsOperation)
	c:RegisterEffect(e14)
end
function s.adjustop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:GetAttack() ~= c:GetBaseAttack() or c:GetDefense() ~= c:GetBaseDefense() or c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE) then
        c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END, 0, 1)
    end
end
function s.resetCondition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end

function s.resetOriginalStatsOperation(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if not c or not c.GetOriginalAttack then return end  -- Prevent calling on nil or invalid objects
    if c:GetAttack() ~= c:GetOriginalAttack() then
        c:SetAttack(c:GetOriginalAttack())  -- Reset attack to original value
    end
    if c.GetOriginalDefense and c:GetDefense() ~= c:GetOriginalDefense() then
        c:SetDefense(c:GetOriginalDefense())  -- Reset defense to original value
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
function s.efilter(e, te)
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
            (te:GetCategory() & (
            CATEGORY_DESTROY +
            CATEGORY_TOHAND +
            CATEGORY_TODECK +
            CATEGORY_TOGRAVE +
            CATEGORY_RELEASE +
            CATEGORY_REMOVE
            )) ~= 0) then
            return true
        end
    end
    return false
end
function s.stgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
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
-------------------------------------------------------------------
function s.adval(e,c)
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_HAND,0)*1000
end
-------------------------------------------------------------------
function s.atkfilter(c,p,e)
	return c:IsControler(p) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsHasEffect(EFFECT_CANNOT_ATTACK_ANNOUNCE)
		and not c:IsHasEffect(EFFECT_FORBIDDEN) and not c:IsHasEffect(EFFECT_CANNOT_ATTACK)
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ATTACK_ANNOUNCE)
		and not Duel.IsPlayerAffectedByEffect(tp,EFFECT_CANNOT_ATTACK)
		or c:IsHasEffect(EFFECT_UNSTOPPABLE_ATTACK)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return eg:IsContains(chkc) and s.atkfilter(chkc,1-tp,e) end
	if chk==0 then return eg:IsExists(s.atkfilter,1,nil,1-tp,e) end
	Duel.SetTargetCard(eg:Filter(s.atkfilter,nil,1-tp,e))
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards(e):Filter(Card.IsFaceup,nil)
	if #g==0 then return end
	local dg=Group.CreateGroup()
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if tc:GetAttack()==0 then dg:AddCard(tc) end
		elseif tc:IsPosition(POS_FACEUP_DEFENSE) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(-2000)
			e1:SetReset(RESET_EVENT|RESETS_STANDARD)
			tc:RegisterEffect(e1)
			if tc:GetDefense()==0 then dg:AddCard(tc) end
		end
	end
	if #dg==0 then return end
	Duel.BreakEffect()
	Duel.Destroy(dg,REASON_EFFECT)
end