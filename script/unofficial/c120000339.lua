--超魔神イド
function c120000339.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(120000339,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetProperty(EFFECT_FLAG_REPEAT)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ONFIELD)
	e1:SetTarget(c120000339.destg)
	e1:SetOperation(c120000339.desop)
	c:RegisterEffect(e1)
	--revive
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(c120000339.regcon)
	e2:SetOperation(c120000339.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(120000339,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetCountLimit(1)
	e3:SetCondition(c120000339.spcon)
	e3:SetTarget(c120000339.sptg)
	e3:SetOperation(c120000339.spop)
	c:RegisterEffect(e3)
end
function c120000339.dfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsDestructable()
end
function c120000339.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_MONSTER) 
		and Duel.IsExistingMatchingCard(c120000339.dfilter,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(c120000339.dfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end	
function c120000339.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c120000339.dfilter,tp,LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Destroy(g,REASON_EFFECT)
end
function c120000339.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()==LOCATION_MZONE  and e:GetHandler():IsReason(REASON_DESTROY)
end
function c120000339.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsReason(REASON_BATTLE+REASON_DESTROY) and c:IsPreviousLocation(LOCATION_ONFIELD) then
		c:RegisterFlagEffect(120000339,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c120000339.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(120000339)~=0
end
function c120000339.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,1,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c120000339.spop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SpecialSummon(e:GetHandler(),1,tp,tp,false,false,POS_FACEUP)
	end
end