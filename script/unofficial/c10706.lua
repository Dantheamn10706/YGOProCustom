--Dark Magician the Arcane Ascendant
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()
    -- Synchro Summon procedure:
    Synchro.AddProcedure(c, nil, 1, 1, Synchro.NonTunerEx(s.matfilter), 1, 99, s.tunfilter)

    -- Name becomes "Dark Magician" if DM is on the field or in a GY
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCode(EFFECT_CHANGE_CODE) -- Changed from ADD_CODE to CHANGE_CODE
    e1:SetCondition(s.namecon)
    e1:SetValue(46986414) -- Dark Magician ID
    c:RegisterEffect(e1)

    -- Gains 500 ATK for each Spell/Trap in your GY
    local e2=Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)

    -- Quick Effect: negate activation
    -- Cost: banish 1 Spell/Trap from your GY
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,0))
    e3:SetCategory(CATEGORY_NEGATE)
    e3:SetType(EFFECT_TYPE_QUICK_O)
    e3:SetCode(EVENT_CHAINING)
    e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.negcon)
    e3:SetCost(s.negcost)
    e3:SetTarget(s.negtg)
    e3:SetOperation(s.negop)
    c:RegisterEffect(e3)
end

-- references
s.listed_names={46986414,38033121} -- DM, DM Girl
s.listed_series={SET_PALLADIUM}

-------------------------------------------------
-- Synchro helpers
-------------------------------------------------
function s.tunfilter(c,scard,sumtype,tp)
    return c:IsOriginalCode(46986414)
end

function s.matfilter(c,scard,sumtype,tp)
    return true
end

-------------------------------------------------
-- Name becomes "Dark Magician"
-------------------------------------------------
function s.namefilter(c)
    -- Check for the original ID 46986414 (Dark Magician)
    return c:IsOriginalCode(46986414)
end

function s.namecon(e)
    local tp=e:GetHandlerPlayer()
    -- We exclude 'e:GetHandler()' (this card itself) to prevent potential loops/errors
    return Duel.IsExistingMatchingCard(
        s.namefilter,tp,
        LOCATION_ONFIELD|LOCATION_GRAVE,
        LOCATION_ONFIELD|LOCATION_GRAVE,
        1,e:GetHandler()
    )
end

-------------------------------------------------
-- +500 ATK per Spell/Trap in YOUR GY
-------------------------------------------------
function s.atkfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(s.atkfilter,c:GetControler(),LOCATION_GRAVE,0,nil)*500
end

-------------------------------------------------
-- Count different Palladium / DM / DMG
-------------------------------------------------
function s.limitfilter(c)
    return (c:IsFaceup() or c:IsLocation(LOCATION_GRAVE))
        and ((c:IsSetCard(SET_PALLADIUM) and c:IsMonster())
            or c:IsCode(46986414,38033121)) -- DM, DM Girl
end
function s.maxnegates(tp)
    local g=Duel.GetMatchingGroup(
        s.limitfilter,tp,
        LOCATION_ONFIELD|LOCATION_GRAVE,
        LOCATION_ONFIELD|LOCATION_GRAVE,
        nil
    )
    return g:GetClassCount(Card.GetCode)
end

-------------------------------------------------
-- Quick Effect negate
-------------------------------------------------
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    if rp==tp or not Duel.IsChainNegatable(ev) then return false end
    local c=e:GetHandler()
    local max=s.maxnegates(tp)
    return max>0 and c:GetFlagEffect(id)<max
end

function s.costfilter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function s.negcost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_GRAVE,0,1,nil)
    end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,s.costfilter,tp,LOCATION_GRAVE,0,1,1,nil)
    Duel.Remove(g,POS_FACEUP,REASON_COST)
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function s.negop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if Duel.NegateActivation(ev) and c:IsRelateToEffect(e) and c:IsFaceup() then
        c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
    end
end