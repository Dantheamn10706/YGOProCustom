--Millennium Scales
local s,id=GetID()
function s.initial_effect(c)
    -- Activate as Continuous Spell
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e1)

    -- Fusion Summon from hand/field by discarding a Spell
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_FUSION_SUMMON)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
    e2:SetCost(s.cost)
    e2:SetTarget(Fusion.SummonEffTG(Fusion.OnFieldOrInHand))
    e2:SetOperation(Fusion.SummonEffOP(Fusion.OnFieldOrInHand))
    c:RegisterEffect(e2)
end

-- Cost: Discard 1 Spell card
function s.costfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsDiscardable()
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND,0,1,nil) end
    Duel.DiscardHand(tp,s.costfilter,1,1,REASON_COST+REASON_DISCARD)
end
