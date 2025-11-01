--Orichalcos Shunoros
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- Must be Special Summoned by Kyutora
    local e1=Effect.CreateEffect(c)
    e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SPSUMMON_CONDITION)
    e1:SetValue(s.splimit)
    c:RegisterEffect(e1)

    -- Set ATK based on absorbed damage
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetCondition(s.atkcon)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)

    -- Lose ATK after battle
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_BATTLED)
    e3:SetCondition(s.battlecon)
    e3:SetOperation(s.battleop)
    c:RegisterEffect(e3)

    -- Summon Divine Serpent Geh if destroyed with 0 ATK and 10k LP
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
    e4:SetCode(EVENT_DESTROYED)
    e4:SetCondition(s.gehcon)
    e4:SetTarget(s.gehtg)
    e4:SetOperation(s.gehop)
    c:RegisterEffect(e4)
end

-- Only allow summon via Kyutora
function s.splimit(e,se,sp,st)
    return se and se:GetHandler():IsCode(170000166)
end

-- Check for Kyutora damage flag
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetFlagEffect(170000166+100)>0
end

-- Set base ATK to absorbed damage
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local val=c:GetFlagEffectLabel(170000166+100) or 0
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_SET_BASE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(val)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD_DISABLE)
    c:RegisterEffect(e1)
end

-- Lose ATK equal to opponent's monster ATK or DEF depending on position
function s.battlecon(e,tp,eg,ep,ev,re,r,rp)
    return e:GetHandler():GetBattleTarget()~=nil
end
function s.battleop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    local bc=c:GetBattleTarget()
    if not bc then return end
    local val = 0
    if bc:IsAttackPos() then val = bc:GetAttack()
    elseif bc:IsDefensePos() then val = bc:GetDefense() end
    if val < 0 then val = 0 end
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetValue(-val)
    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
    c:RegisterEffect(e1)
end

-- Divine Serpent Geh summon
function s.gehcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    return c:IsReason(REASON_DESTROY) and c:GetPreviousAttackOnField()==0 and Duel.GetLP(tp)>=10000
end
function s.gehfilter(c,e,tp)
    return c:IsCode(82103466) and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
end
function s.gehtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
        and Duel.IsExistingMatchingCard(s.gehfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK)
end
function s.gehop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local tc=Duel.SelectMatchingCard(tp,s.gehfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil,e,tp):GetFirst()
    if tc then
        Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
        tc:CompleteProcedure()
    end
end
