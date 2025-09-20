--Dark Magician the Arcane Ascendant
local s,id=GetID()
function s.initial_effect(c)
    c:EnableReviveLimit()

    -- Synchro Summon procedure: "Dark Magician" as Tuner + 1+ non-Tuners
    Synchro.AddProcedure(c, nil, 1, 1, Synchro.NonTunerEx(s.matfilter), 1, 99, s.tunfilter)

    -- Gains 500 ATK for each Spell/Trap on the field
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_UPDATE_ATTACK)
    e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e1:SetRange(LOCATION_MZONE)
    e1:SetValue(s.atkval)
    c:RegisterEffect(e1)

    -- Once per turn: negate destruction/send-to-GY/targeting effects
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_NEGATE)
    e2:SetType(EFFECT_TYPE_QUICK_O)
    e2:SetCode(EVENT_CHAINING)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1)
    e2:SetCondition(s.negcon)
    e2:SetTarget(s.negtg)
    e2:SetOperation(s.negop)
    c:RegisterEffect(e2)

    -- Once per turn: send 1 S/T you control to GY; destroy 1 opponent's S/T
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCountLimit(1)
    e3:SetTarget(s.sptg)
    e3:SetOperation(s.spop)
    c:RegisterEffect(e3)
end

-- Tuner requirement: must be "Dark Magician"
function s.tunfilter(c,scard,sumtype,tp)
    return c:IsOriginalCodeRule(46986414)
end

-- Non-Tuners: allow any
function s.matfilter(c)
    return true
end

-- ATK boost based on total Spell/Traps
function s.atkval(e,c)
    return Duel.GetMatchingGroupCount(function(tc)
        return tc:IsType(TYPE_SPELL+TYPE_TRAP)
    end, c:GetControler(), LOCATION_ONFIELD, LOCATION_ONFIELD, nil) * 500
end

-- Negation condition
function s.negcon(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if c:IsStatus(STATUS_BATTLE_DESTROYED) or not re or not Duel.IsChainDisablable(ev) then return false end

    local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
    if re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) and tg and tg:IsContains(c) then
        return true
    end

    local ex1,g1=Duel.GetOperationInfo(ev,CATEGORY_DESTROY)
    if g1 and g1:IsContains(c) then return true end

    local ex2,g2=Duel.GetOperationInfo(ev,CATEGORY_TOGRAVE)
    if g2 and g2:IsContains(c) then return true end

    return false
end

function s.negtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end

function s.negop(e,tp,eg,ep,ev,re,r,rp)
    Duel.NegateEffect(ev)
end

-- Destroy opponent's S/T by sending your own
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        return Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP)
            and Duel.IsExistingMatchingCard(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP)
    end
    Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_ONFIELD)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local g1=Duel.SelectMatchingCard(tp,Card.IsType,tp,LOCATION_ONFIELD,0,1,1,nil,TYPE_SPELL+TYPE_TRAP)
    if #g1==0 or Duel.SendtoGrave(g1,REASON_EFFECT)==0 then return end

    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
    local g2=Duel.SelectMatchingCard(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
    if #g2>0 then
        Duel.Destroy(g2,REASON_EFFECT)
    end
end
