--Dragon of the Black Rite
--Custom card for Anime Style Duel / DeltaBagooska
--Fusion Materials: ("Magician of Black Chaos" or 1 Level 8 Spellcaster) + 1 Dragon
--Summon: Fusion Summon OR Special Summoned by custom anime "The Eye of Timaeus" (511004100)
local s,id=GetID()

--local CARD_MAGICIAN_OF_BLACK_CHAOS=30208479

function s.initial_effect(c)
	--Fusion Procedure: (Magician of Black Chaos OR any Level 8 Spellcaster) + 1 Dragon
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,{30208479,40737112,s.mfilter},aux.FilterBoolFunctionEx(Card.IsRace,RACE_DRAGON))
	--Must be Fusion Summoned, or Special Summoned by custom "The Eye of Timaeus"
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(s.splimit)
	c:RegisterEffect(e0)

	--(1) Tribute 1 other monster: opponent cannot activate monster effects this turn
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tdcost)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)

	--(2) Banish monsters destroyed by battle with this card
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_BATTLE_DESTROY_REDIRECT)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetValue(LOCATION_REMOVED)
	c:RegisterEffect(e2)

	--(3) When this card destroys an opponent's monster by battle: add 1 Spell from GY to hand
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_BATTLE_DESTROYING)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)

	--(4) If destroyed by battle or card effect: Special Summon a Level 8 "Chaos" Spellcaster
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,2))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetTarget(s.sptg)
	e4:SetOperation(s.spop)
	c:RegisterEffect(e4)
end

--Listed references and material info
s.material={CARD_MAGICIAN_OF_BLACK_CHAOS}
s.listed_names={CARD_MAGICIAN_OF_BLACK_CHAOS,511004100}

--Material filter: Level 8 Spellcaster (as alternate to Magician of Black Chaos)
function s.mfilter(c,fc,sumtype,tp)
	return c:IsRace(RACE_SPELLCASTER,fc,sumtype,tp) and c:IsLevel(8)
end

--Summon limit: Fusion Summon only, or Special Summoned by custom anime Timaeus
function s.splimit(e,se,sp,st)
	return (st&SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
		or (se and se:GetHandler():IsCode(511004100))
end

--(1) Cost: Tribute 1 other monster
function s.costfilter(c,tc)
	return c:IsReleasableByEffect() and c~=tc
end
function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_MZONE,0,1,nil,e:GetHandler()) end
	local g=Duel.SelectReleaseGroup(tp,s.costfilter,1,1,REASON_COST,false,nil,nil,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
--(1) Operation: opponent cannot activate monster effects this turn
function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(0,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE+LOCATION_ONFIELD)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2:SetTargetRange(0,1)
	e2:SetValue(s.actlimit)
	Duel.RegisterEffect(e2,tp)
end
function s.actlimit(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER)
end

--(3) Add Spell from GY to hand when destroying opponent monster by battle
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsPreviousControler(1-tp) and bc:IsPreviousLocation(LOCATION_MZONE) and bc:IsReason(REASON_BATTLE)
end
function s.thfilter(c)
	return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,tp,LOCATION_GRAVE)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsLocation(LOCATION_GRAVE) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end

--(4) Special Summon a Level 8 "Chaos" Spellcaster, ignoring Summoning conditions
function s.spfilter(c,e,tp)
	return c:IsSetCard(0x10) --"Chaos" archetype setcode
		and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_SPELLCASTER)
		and c:IsLevel(8)
		and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
	end
end