--Red-Eyes Alternative Ultimate Dragon
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.matfilter,3)

	-- Cannot be targeted by opponent’s card effects
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetValue(aux.tgoval)
	c:RegisterEffect(e0)

	-- Cannot be destroyed by opponent’s card effects
	local e1=e0:Clone()
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetValue(1)
	c:RegisterEffect(e1)

	-- Unified Quick Effect Menu (multi-use per turn if options remain)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_SPECIAL_SUMMON+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e2:SetCondition(function(e,tp) return s.menu_has_options(e:GetHandler(),tp) end)
	e2:SetTarget(s.effectmenutg)
	e2:SetOperation(s.effectmenuop)
	c:RegisterEffect(e2)

	-- Burn if sent to GY by opponent
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(s.tgcon)
	e3:SetOperation(s.tgop)
	c:RegisterEffect(e3)

	-- Material check
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_MATERIAL_CHECK)
	e4:SetValue(s.valcheck)
	c:RegisterEffect(e4)

	-- Debug message
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetOperation(s.debugop)
	c:RegisterEffect(e5)
end

function s.matfilter(c,scard,sumtype,tp)
	return c:IsSetCard(0x3b,scard,sumtype,tp)
end

function s.valcheck(e,c)
	local count=c:GetMaterial():FilterCount(Card.IsCode,nil,18491580)
	if count>0 then
		c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD&~(RESET_TOFIELD|RESET_TEMP_REMOVE|RESET_LEAVE),
			EFFECT_FLAG_CLIENT_HINT,1,count,aux.Stringid(id,2))
	end
end

function s.menu_has_options(c,tp)
	local ct=c:GetFlagEffectLabel(id) or 0
	if ct>=1 and Duel.GetFlagEffect(tp,id+11)==0 then return true end
	if ct>=2 and Duel.GetFlagEffect(tp,id+12)==0 then return true end
	if ct>=3 and Duel.GetFlagEffect(tp,id+13)==0 then return true end
	return false
end

function s.effectmenutg(e,tp,eg,ep,ev,re,r,rp,chk)
	return true
end

function s.effectmenuop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(id) or 0

	local opts = {}
	local strmap = {}
	local flagmap = {}

	if ct>=1 and Duel.GetFlagEffect(tp,id+11)==0 then
		table.insert(opts,1)
		strmap[1] = aux.Stringid(id,1)
		flagmap[1] = id+11
	end
	if ct>=2 and Duel.GetFlagEffect(tp,id+12)==0 then
		table.insert(opts,2)
		strmap[2] = aux.Stringid(id,2)
		flagmap[2] = id+12
	end
	if ct>=3 and Duel.GetFlagEffect(tp,id+13)==0 then
		table.insert(opts,3)
		strmap[3] = aux.Stringid(id,3)
		flagmap[3] = id+13
	end

	if #opts==0 then return end

	local choices = {}
	for _,i in ipairs(opts) do
		table.insert(choices,strmap[i])
	end
	local sel = Duel.SelectOption(tp,table.unpack(choices))+1
	local chosen = opts[sel]

	if chosen==1 then
		-- Burn and summon (level 4 or lower)
		local mult = (ct>=2) and 1200 or 600
		local num = Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0x3b)
		Duel.Damage(1-tp,num*mult,REASON_EFFECT)
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local g=Duel.SelectMatchingCard(tp,function(c)
				return c:IsSetCard(0x3b) and c:IsLevelBelow(4) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end,tp,LOCATION_GRAVE,0,1,1,nil)
			if #g>0 then Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP) end
		end
		Duel.RegisterFlagEffect(tp,id+11,0,0,0)

	elseif chosen==2 then
		-- Add Red-Eyes Spell/Trap + Special Summon any Red-Eyes
		local g=Duel.SelectMatchingCard(tp,function(c)
			return c:IsSetCard(0x3b) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
		end,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
		if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
			local g2=Duel.SelectMatchingCard(tp,function(c)
				return c:IsSetCard(0x3b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
			end,tp,LOCATION_GRAVE,0,1,1,nil)
			if #g2>0 then Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP) end
		end
		Duel.RegisterFlagEffect(tp,id+12,0,0,0)

	elseif chosen==3 then
		-- Banish self, Special Summon Red-Eyes from Extra Deck
		if not c:IsRelateToEffect(e) or not Duel.Remove(c,POS_FACEUP,REASON_EFFECT) then return end
		if Duel.GetLocationCountFromEx(tp)>0 then
			local g=Duel.GetMatchingGroup(function(c)
				return c:IsSetCard(0x3b) and c:IsType(TYPE_MONSTER)
					and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_SPECIAL,tp,true,true)
					and c:IsLocation(LOCATION_EXTRA)
			end,tp,LOCATION_EXTRA,0,nil)
			if #g>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local sg=g:Select(tp,1,1,nil)
				Duel.SpecialSummon(sg,SUMMON_TYPE_SPECIAL,tp,tp,true,true,POS_FACEUP)
			end
		end
		Duel.RegisterFlagEffect(tp,id+13,0,0,0)
	end
end

function s.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Damage(1-tp,1000,REASON_EFFECT)
end

function s.debugop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetFlagEffectLabel(id) or 0
	Debug.Message("Red-Eyes Alternative Ultimate Dragon was summoned using "..ct.." Red-Eyes Alternative Black Dragon(s).")
end
