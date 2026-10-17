--Custom Dark Sage Variant
local s,id=GetID()

function s.initial_effect(c)
    c:EnableReviveLimit()

    -- Special Summon from hand or deck after Time Wizard resolves
    local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_CUSTOM+71625222)
    e1:SetRange(LOCATION_HAND)
    e1:SetCondition(s.spcon)
    e1:SetCost(s.cost)
    e1:SetTarget(s.sptg)
    e1:SetOperation(s.spop)
    c:RegisterEffect(e1)
    local e2=e1:Clone()
    e2:SetRange(LOCATION_DECK)
    c:RegisterEffect(e2)

    -- Draw Phase replacement: Add Spell instead of drawing
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id,1))
    e3:SetCategory(CATEGORY_TOHAND)
    e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_PREDRAW)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCondition(s.drcon)
    e3:SetTarget(s.drtg)
    e3:SetOperation(s.drop)
    c:RegisterEffect(e3)

    -- While this card is on the field, all Spell Cards in your hand and on your field are treated as Quick-Play Spells
    local e4=Effect.CreateEffect(c)
    e4:SetType(EFFECT_TYPE_FIELD)
    e4:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
    e4:SetCode(EFFECT_BECOME_QUICK)
    e4:SetRange(LOCATION_MZONE)
    e4:SetTargetRange(LOCATION_HAND+LOCATION_SZONE,0)
    e4:SetTarget(aux.TargetBoolFunction(Card.IsSpell))
    c:RegisterEffect(e4)
end

s.listed_names={CARD_DARK_MAGICIAN}

-- Time Wizard trigger
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
    return ep==tp
end

-- Cost: Tribute Dark Magician
function s.costfilter(c,ft,tp)
    return c:IsCode(CARD_DARK_MAGICIAN) and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
    local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,s.costfilter,1,false,nil,nil,ft,tp) end
    if e:GetHandler():IsLocation(LOCATION_DECK) then
        Duel.ConfirmCards(1-tp,e:GetHandler())
    end
    local g=Duel.SelectReleaseGroupCost(tp,s.costfilter,1,1,false,nil,nil,ft,tp)
    Duel.Release(g,REASON_COST)
end

-- Special Summon target + operation
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,true,false) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,e:GetHandler():GetLocation())
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
    if not c:IsRelateToEffect(e) then return end
    if Duel.SpecialSummon(c,0,tp,tp,true,false,POS_FACEUP)~=0 then
        c:CompleteProcedure()
    end
end

-- Draw Phase replacement logic
function s.drcon(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp and Duel.GetDrawCount(tp)>0
        and Duel.IsExistingMatchingCard(s.spellfilter,tp,LOCATION_DECK,0,1,nil)
end
function s.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return true end
    local e1=Effect.CreateEffect(e:GetHandler())
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetCode(EFFECT_DRAW_COUNT)
    e1:SetTargetRange(1,0)
    e1:SetReset(RESET_PHASE+PHASE_DRAW)
    e1:SetValue(0)
    Duel.RegisterEffect(e1,tp)
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.drop(e,tp,eg,ep,ev,re,r,rp)
    if Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
        local g=Duel.SelectMatchingCard(tp,s.spellfilter,tp,LOCATION_DECK,0,1,1,nil)
        if #g>0 then
            Duel.SendtoHand(g,nil,REASON_EFFECT)
            Duel.ConfirmCards(1-tp,g)
        end
    else
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_DRAW_COUNT)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE+PHASE_DRAW)
        e1:SetValue(1)
        Duel.RegisterEffect(e1,tp)
    end
end

function s.spellfilter(c)
    return c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
