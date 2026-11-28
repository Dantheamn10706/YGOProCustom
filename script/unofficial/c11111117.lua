--Millennium Puzzle
local s,id=GetID()
function s.initial_effect(c)
    -- Activate like a Spell Card
    local e0=Effect.CreateEffect(c)
    e0:SetType(EFFECT_TYPE_ACTIVATE)
    e0:SetCode(EVENT_FREE_CHAIN)
    e0:SetCondition(s.act_condition)
    c:RegisterEffect(e0)

    -- Replace Draw
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_FIELD)
    e1:SetCode(EFFECT_DRAW_COUNT)
    e1:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
    e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
    e1:SetTargetRange(1,0)
    e1:SetCondition(s.draw_condition)
    e1:SetValue(0)
    c:RegisterEffect(e1)

    -- Add card instead of drawing
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id,0))
    e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
    e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
    e2:SetCode(EVENT_PREDRAW)
    e2:SetRange(LOCATION_SZONE+LOCATION_GRAVE)
    e2:SetCountLimit(1,id)
    e2:SetCondition(s.draw_condition)
    e2:SetTarget(s.thtg)
    e2:SetOperation(s.thop)
    c:RegisterEffect(e2)
end

function s.act_condition(e,tp,eg,ep,ev,re,r,rp)
    if not tp then return false end
    return Duel.GetLP(tp)<Duel.GetLP(1-tp)
        or Duel.IsExistingMatchingCard(function(c) return c:IsFaceup() and c:IsSetCard(0xf0f0) end,tp,0,LOCATION_ONFIELD,1,nil)
end

function s.draw_condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetTurnPlayer()==tp
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK,0,1,nil) end
    local dt=Duel.GetDrawCount(tp)
    if dt~=0 then
        local e1=Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_FIELD)
        e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
        e1:SetCode(EFFECT_DRAW_COUNT)
        e1:SetTargetRange(1,0)
        e1:SetReset(RESET_PHASE|PHASE_DRAW)
        e1:SetValue(0)
        Duel.RegisterEffect(e1,tp)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
    local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK,0,1,1,nil)
    if #g>0 then
        Duel.SendtoHand(g,nil,REASON_EFFECT)
        Duel.ConfirmCards(1-tp,g)
    end
end
