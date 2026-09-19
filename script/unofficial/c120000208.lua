--SR－OMKガム
function c120000208.initial_effect(c)
	--nonormalsummon
	c:EnableUnsummonable()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000208,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCode(EVENT_DAMAGE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c120000208.spcon)
	e1:SetTarget(c120000208.sptg)
	e1:SetOperation(c120000208.spop)
	c:RegisterEffect(e1)
	--synchro summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(120000208,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(TIMING_SPSUMMON)
	e2:SetHintTiming(TIMING_BATTLE_STEP_END+TIMING_BATTLE_END)
	e2:SetCondition(c120000208.sccon)
	e2:SetTarget(c120000208.sctg)
	e2:SetOperation(c120000208.scop)
	c:RegisterEffect(e2)
	--deckdes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000208,2))
	e3:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetCondition(c120000208.atkcon)
	e3:SetTarget(c120000208.atktg)
	e3:SetOperation(c120000208.atkop)
	c:RegisterEffect(e3)
end
function c120000208.spcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and  Duel.GetCurrentPhase()>=PHASE_BATTLE_START and Duel.GetCurrentPhase()<=PHASE_BATTLE  
end
function c120000208.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000208.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		c:RegisterFlagEffect(120000208,RESET_EVENT+0x1ec0000,0,1)
	end
end
function c120000208.sccon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(120000208)~=0
end
function c120000208.mfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsFaceup()
end
function c120000208.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local mg=Duel.GetMatchingGroup(c120000208.mfilter,tp,LOCATION_MZONE,0,nil)
		return not c:IsStatus(STATUS_CHAINING)
			and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,c,mg)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c120000208.scop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:GetControler()~=tp or not c:IsRelateToEffect(e) then return end
	local mg=Duel.GetMatchingGroup(c120000208.mfilter,tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,c,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),c,mg)
	end
end
function c120000208.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c120000208.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)	
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c120000208.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	local g=Duel.GetDecktopGroup(p,1)
	local tg=g:GetFirst()
	if Duel.Draw(p,d,REASON_EFFECT)~=0 then
		Duel.ConfirmCards(1-p,tg)
		Duel.SendtoGrave(tg,REASON_EFFECT)
		if tg and tg:IsType(TYPE_MONSTER) and tg:IsSetCard(0x2016) then
			--atk
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(tg:GetBaseAttack())
			e1:SetReset(RESET_EVENT+0x1ff0000)
			rc:RegisterEffect(e1)
		end	
	end
end	
