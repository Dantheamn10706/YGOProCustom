--Legend of Justice Kaibaman
local s,id=GetID()
function s.initial_effect(c)
    -- Special Summon Blue-Eyes when this card is Normal or Special Summoned
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_SUMMON_SUCCESS)
    e1:SetCountLimit(1,id)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    c:RegisterEffect(e2)

    -- Search "Blue-Eyes" monster if a Blue-Eyes is Special Summoned while this is in GY
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetRange(LOCATION_GRAVE)
    e3:SetCountLimit(1,id+100)
    e3:SetCondition(s.thcon)
    e3:SetCost(aux.bfgcost)
    e3:SetTarget(s.thtg)
    e3:SetOperation(s.thop)
    c:RegisterEffect(e3)
end

-- Blue-Eyes reveal filter for initial effect
function s.reveal_filter(c)
    return c:IsCode(89631139) and (
        c:IsLocation(LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE) or
        (c:IsLocation(LOCATION_MZONE) and c:IsFaceup())
    )
end

-- Special Summon filter
function s.spfilter(c,e,tp)
    return c:IsCode(89631139) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

-- Target function
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    local g=Duel.GetMatchingGroup(s.reveal_filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
    if chk==0 then return g:GetCount()>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
        and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE)
end

-- Operation function
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    local g=Duel.GetMatchingGroup(s.reveal_filter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_MZONE+LOCATION_GRAVE,0,nil)
    if #g<3 then return end

    -- Reveal 3 Blue-Eyes cards
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
    local rg=g:Select(tp,3,3,nil)
    Duel.ConfirmCards(1-tp,rg)

    -- Special Summon 1 Blue-Eyes from hand, deck, or grave
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local sg=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil,e,tp)
    if #sg>0 then
        Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
    end
end

-- Condition: A Blue-Eyes was Special Summoned by the player
function s.thcfilter(c,tp)
    return c:IsCode(89631139) and c:IsControler(tp)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
    return eg:IsExists(s.thcfilter,1,nil,tp)
end

-- Search filter for Blue-Eyes monsters
function s.thfilter(c)
    return c:IsSetCard(0xdd) and c:IsMonster() and c:IsAbleToHand()
end

-- Target for search effect
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

-- Search operation
function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
