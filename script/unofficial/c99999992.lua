--Millennium Stone
local s,id=GetID()
function s.initial_effect(c)
    -- Activate
    local e1=Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

-- List of required card IDs (Millennium Items)
local REQUIRED_IDS = {
    11111111, -- Eye
    11111112, -- Key
    11111113, -- Scales
    11111114, -- Necklace
    11111115, -- Rod
    11111116, -- Ring
    11111117  -- Puzzle
}

function s.hasAllItems(tp)
    local g = Group.CreateGroup()
    for _,id in ipairs(REQUIRED_IDS) do
        local match = Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil,id)
        if #match==0 then return false end
        g:Merge(match)
    end
    return #g>=7
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then
        if Duel.GetLocationCountFromEx(tp)<=0 then return false end
        local zork=Duel.IsExistingMatchingCard(s.zorkfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
        if not zork then return false end
        return s.hasAllItems(tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function s.zorkfilter(c,e,tp)
    return c:IsCode(99999991) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end

function s.activate(e,tp,eg,ep,ev,re,r,rp)
    if not s.hasAllItems(tp) then return end
    local all=Group.CreateGroup()
    for _,id in ipairs(REQUIRED_IDS) do
        local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK,0,nil,id)
        if #g>0 then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
            local sg=g:Select(tp,1,1,nil)
            all:Merge(sg)
        else
            return
        end
    end
    Duel.Remove(all,POS_FACEUP,REASON_EFFECT)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectMatchingCard(tp,s.zorkfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
    if #g>0 then
        Duel.SpecialSummon(g,0,tp,tp,true,true,POS_FACEUP)
    end
end
