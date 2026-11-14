--蒼炎の剣士
local s,id=GetID()
function s.initial_effect(c)
	--atkdown
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
        e1:SetCountLimit(1)
	e1:SetCost(s.cost)
	e1:SetTarget(s.target)
	e1:SetOperation(s.operation)
	c:RegisterEffect(e1)
        --Flame rise
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_TO_GRAVE)
	e6:SetCondition(s.erascon)
	e6:SetTarget(s.tar)
	e6:SetOperation(s.activate)
	c:RegisterEffect(e6)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttack()>=100 end
	local atk=e:GetHandler():GetAttack()
	local al=100
	if atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700,1800)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600,1700)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500,1600)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400,1500)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300,1400)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200,1300)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100,1200)
	elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000,1100)
    elseif atk>=1000 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900,1000)
    elseif atk>=900 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800,900)
    elseif atk>=800 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700,800)
    elseif atk>=700 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600,700)
    elseif atk>=600 then al=Duel.AnnounceNumber(tp,100,200,300,400,500,600)
	elseif atk>=500 then al=Duel.AnnounceNumber(tp,100,200,300,400,500)
	elseif atk>=400 then al=Duel.AnnounceNumber(tp,100,200,300,400)
	elseif atk>=300 then al=Duel.AnnounceNumber(tp,100,200,300)
	elseif atk>=200 then al=Duel.AnnounceNumber(tp,100,200)
	end
	s.atkchange(e:GetHandler(),-al)
	e:SetLabel(al)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
        local c=e:GetHandler()
	if chkc then return chkc~=c and s.filter(chkc,e) and chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then
	    return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,c,e)
	end
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,c,e)
	Duel.SetTargetCard(g)
end
function s.filter(c,e)
        return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	if not tc or not tc:IsRelateToEffect(e) or not c:IsRelateToEffect(e) then return end
        s.atkchange(tc,e:GetLabel())
end
function s.atkchange(c,atkval)
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT+0x1fe0000)
        e1:SetValue(atkval)
        c:RegisterEffect(e1)
end
function s.erascon(e)
	return e:GetHandler():IsReason(REASON_DESTROY) or e:GetHandler():IsReason(REASON_BATTLE)
end
function s.spfilter(c,e,tp)
    return (c:IsCode(511001128) or c:IsCode(45231177)) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tar(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.spfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
	if #g>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end